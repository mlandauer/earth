require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # TODO: Tests currently hardcoded for a specific user. Make them more general.
  def test_name
    user = User.new(3054)
    # Only do the following tests if ldap is configured
    if User.config["ldap_server_name"]
      assert_equal("kenji", user.name)
    end
  end
  
  def test_no_ldap_configured
    saved_ldap_server_name = User.config["ldap_server_name"]
    User.config["ldap_server_name"] = nil
    user = User.new(100)
    assert_equal("100", user.name)
    User.config["ldap_server_name"] = saved_ldap_server_name
  end
end
