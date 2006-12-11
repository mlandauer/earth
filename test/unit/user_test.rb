require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # TODO: Tests currently hardcoded for a specific user. Make them more general.
  def test_lookup_name_by_uid
    assert_equal("kenji", User.lookup_name_by_uid(3054))
  end
  
  def test_no_ldap_configured
    User.ldap_server_name = nil
    assert_equal("100", User.lookup_name_by_uid(100))
  end
end
