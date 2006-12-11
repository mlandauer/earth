require File.dirname(__FILE__) + '/../test_helper'

class OwnershipTest < Test::Unit::TestCase
  # TODO: Tests currently hardcoded for a specific user. Make them more general.
  def test_name
    ownership = Ownership.new(3054, 20)
    assert_equal("kenji", ownership.user_name)
    assert_equal("users", ownership.group_name)
  end
  
  def test_no_ldap_configured
    saved_ldap_server_name = Ownership.ldap_server_name
    Ownership.ldap_server_name = nil
    ownership = Ownership.new(100, 200)
    assert_equal("100", ownership.user_name)
    assert_equal("200", ownership.group_name)
    Ownership.ldap_server_name = saved_ldap_server_name
  end
end
