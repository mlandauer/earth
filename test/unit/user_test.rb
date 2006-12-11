require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # TODO: Tests currently hardcoded for a specific user. Make them more general.
  def test_name
    assert_equal("kenji", User.new(3054).name)
  end
  
  def test_no_ldap_configured
    User.ldap_server_name = nil
    assert_equal("100", User.new(100).name)
  end
end
