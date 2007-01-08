require File.dirname(__FILE__) + '/../../test_helper'

class ApplicationHelperTest < HelperTestCase

  include ApplicationHelper

  def test_human_units_of
    assert_equal("Bytes", human_units_of(500))
    assert_equal("KB", human_units_of(5 * 1024))
    assert_equal("MB", human_units_of(5 * 1024 * 1024))
    assert_equal("GB", human_units_of(5 * 1024 * 1024 * 1024))
    assert_equal("TB", human_units_of(5 * 1024 * 1024 * 1024 * 1024))
    assert_equal("TB", human_units_of(5 * 1024 * 1024 * 1024 * 1024 * 1024))
  end
  
  def test_human_size_in
    assert_equal("500", human_size_in("Bytes", 500))
    assert_equal("0.5", human_size_in("KB",    500))
    assert_equal("> 0", human_size_in("MB",    500))

    assert_equal("5120", human_size_in("Bytes", 5 * 1024))
    assert_equal("5",    human_size_in("KB",    5 * 1024))
    assert_equal("> 0",  human_size_in("MB",    5 * 1024))

    assert_equal("5242880", human_size_in("Bytes", 5 * 1024 * 1024))
    assert_equal("5120",    human_size_in("KB",    5 * 1024 * 1024))
    assert_equal("5",       human_size_in("MB",    5 * 1024 * 1024))
  end
  
  def test_human_size_in_zero
    assert_equal("0", human_size_in("Bytes", 0))
    assert_equal("0", human_size_in("KB", 0))
    assert_equal("0", human_size_in("MB", 0))
    
    assert_equal("1", human_size_in("Bytes", 1))
    assert_equal("> 0", human_size_in("KB", 1))
    assert_equal("> 0", human_size_in("MB", 1))
  end
end
