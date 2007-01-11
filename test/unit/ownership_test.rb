require File.dirname(__FILE__) + '/../test_helper'

class OwnershipTest < Test::Unit::TestCase
  # TODO: Tests currently hardcoded for a specific user. Make them more general.
  def test_name
    ownership = Ownership.new(3054)
    # Only do the following tests if ldap is configured
    if Ownership.config["ldap_server_name"]
      assert_equal("kenji", ownership.user_name)
    end
  end
  
  def test_no_ldap_configured
    saved_ldap_server_name = Ownership.config["ldap_server_name"]
    Ownership.config["ldap_server_name"] = nil
    ownership = Ownership.new(100)
    assert_equal("100", ownership.user_name)
    Ownership.config["ldap_server_name"] = saved_ldap_server_name
  end
end
