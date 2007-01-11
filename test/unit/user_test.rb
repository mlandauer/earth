require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # TODO: Tests currently hardcoded for a specific user. Make them more general.
  def test_name
    user = User.new(3054)
    # Only do the following tests if ldap is configured
    if User.ldap_configured?
      assert_equal("kenji", user.name)
    else
      assert_equal("3054", user.name)
    end
  end
  
  def test_no_ldap_configured
    saved_ldap_server_name = User.config["ldap_server_name"]
    User.config["ldap_server_name"] = nil
    user = User.new(100)
    assert_equal("100", user.name)
    User.config["ldap_server_name"] = saved_ldap_server_name
  end
  
  def test_find_by_name
    if User.ldap_configured?
      user = User.find_by_name("kenji")
      assert_equal(3054, user.uid)
      assert_equal("kenji", user.name)
    else
      user = User.find_by_name("3054")
      assert_equal(3054, user.uid)
      assert_equal("3054", user.name)
    end
  end
end
