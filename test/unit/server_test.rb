require File.dirname(__FILE__) + '/../test_helper'

class ServerTest < Test::Unit::TestCase
  fixtures :servers, :directories

  def test_this_server
    server = Server.this_server
    assert_equal(Server.this_hostname, server.name)
    assert_equal("/foo", server.directory.path)
  end
  
  def test_server_not_in_db
    Server.this_server.destroy
    # Should create a server record if it doesn't already exist
    server = Server.this_server
    assert_equal(Server.this_hostname, server.name)
    assert_nil(server.directory)
  end  
end
