#!/usr/bin/env ruby

class Test::Unit::TestCase

  ActiveRecord::Base.connection.class.class_eval do
    cattr_accessor :delete_count
    cattr_accessor :delete_log
    alias_method :execute_without_delete_counting, :execute
    def execute_with_delete_counting(sql, name = nil)
      if /\s*DELETE\s+/i =~ sql
        self.delete_count += 1 
        self.delete_log << [ sql, caller[2..-1] ]
      end
      execute_without_delete_counting(sql, name)
    end
  end

  def assert_deletes(num = 1)
    ActiveRecord::Base.connection.class.class_eval do
      self.delete_count = 0
      self.delete_log = []
      alias_method :execute, :execute_with_delete_counting
    end
    yield
  ensure
    ActiveRecord::Base.connection.class.class_eval do
      alias_method :execute, :execute_without_delete_counting
    end
    error_info = ""
    ActiveRecord::Base.connection.delete_log.each do |log_entry|
      error_info += log_entry[0] + "\n"
      error_info += log_entry[1].join("\n    ") + "\n\n"
    end
    assert_equal num, ActiveRecord::Base.connection.delete_count, "#{ActiveRecord::Base.connection.delete_count} instead of #{num} deletes were executed:\n#{error_info}"
  end

  def assert_no_deletes(&block)
    assert_deletes(0, &block)
  end

end
