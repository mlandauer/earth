# Copyright (C) 2007 Rising Sun Pictures and Matthew Landauer
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require File.expand_path(File.dirname(__FILE__) + '/helper_testcase')

require 'test/spec'
require 'mocha'

Hornsby.load

class Test::Unit::TestCase
  include HornsbySpecHelper
  
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  def do_stuff_with_query_counting
    ActiveRecord::Base.connection.class.class_eval do
      self.query_count = 0
      self.delete_count = 0
      self.query_count_log = ""
      alias_method_chain :execute, :query_counting
    end
    yield
  ensure
    ActiveRecord::Base.connection.class.class_eval do
      alias_method :execute, :execute_without_query_counting
    end
  end
  
  # Add more helper methods to be used by all tests here...
  def assert_number_of_sql_queries(num = 1, &block)
    do_stuff_with_query_counting(&block)
    assert_equal num, ActiveRecord::Base.connection.query_count, "#{ActiveRecord::Base.connection.query_count} instead of #{num} queries were executed:\n#{ActiveRecord::Base.connection.query_count_log}"
  end

  def assert_number_of_sql_deletes(num = 1, &block)
    do_stuff_with_query_counting(&block)
    assert_equal num, ActiveRecord::Base.connection.delete_count, "#{ActiveRecord::Base.connection.delete_count} instead of #{num} deletes were executed:\n#{ActiveRecord::Base.connection.query_count_log}"
  end
end

ActiveRecord::Base.connection.class.class_eval do
  cattr_accessor :query_count
  cattr_accessor :delete_count
  cattr_accessor :query_count_log

  # Array of regexes of queries that are not counted against query_count
  @@ignore_list = [/^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/]

  def execute_with_query_counting(sql, name = nil, &block)
    unless @@ignore_list.any? { |r| sql =~ r }
      self.query_count += 1
      self.delete_count += 1 if /\s*DELETE\s+/i =~ sql
      self.query_count_log += sql + "\n"
      self.query_count_log += caller[2..-1].join("\n    ") + "\n\n"
    end
    execute_without_query_counting(sql, name, &block)
  end
end

# snitched from http://fr.ivolo.us/posts/test-unit-mock_model to emulate rspec's mock_model
def mock_model(klass, options = {})    
  default_types = {
  :integer => (1000 + rand(1000)), :string => 'DefaultString', :text => 'DefaultText',
  :datetime => Time.now.utc, :date => Date.today, :boolean => 0, :float => 1.0}
  
  mock_klass = mock(klass.to_s)
  attributes = {}
    
  # for each column, we'll set the attribute hash equal to the default value for the column type
  klass.columns.reject{|c| c unless default_types.has_key?(c.type) }.each do |col|
    attributes[col.name.to_sym] = default_types[col.type.to_sym]
  end
  attributes[:to_param] = mock_klass.id.to_s

  klass_with_name = mock('klass_with_name')
  klass_with_name.stubs(:name).returns(klass.to_s)

  # options passed to this method should override default_types
  attributes.merge!(options)
  
  # Now we'll stub out our mock
  attributes.each do |k,v|
    mock_klass.stubs(k.to_sym).returns(v)
  end

  # this is for mocking associations:
  mock_klass.stubs(:[]=)

  # we want is_a? to return false
  mock_klass.stubs(:is_a?).returns(false)
  # unless called with the class this mock was made from
  mock_klass.stubs(:is_a?).with(klass).returns(true)

  mock_klass.stubs(:new_record?).returns(false)
  mock_klass.stubs(:class).returns(klass_with_name)

  # return the mock
  mock_klass
end
