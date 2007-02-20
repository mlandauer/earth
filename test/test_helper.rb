ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require File.expand_path(File.dirname(__FILE__) + '/helper_testcase')

class Test::Unit::TestCase
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
  def assert_queries(num = 1, &block)
    do_stuff_with_query_counting(&block)
    assert_equal num, ActiveRecord::Base.connection.query_count, "#{ActiveRecord::Base.connection.query_count} instead of #{num} queries were executed:\n#{ActiveRecord::Base.connection.query_count_log}"
  end

  def assert_deletes(num = 1, &block)
    do_stuff_with_query_counting(&block)
    assert_equal num, ActiveRecord::Base.connection.delete_count, "#{ActiveRecord::Base.connection.delete_count} instead of #{num} deletes were executed:\n#{ActiveRecord::Base.connection.query_count_log}"
  end

  def assert_no_queries(&block)
    assert_queries(0, &block)
  end
  
  def assert_no_deletes(&block)
    assert_deletes(0, &block)
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
