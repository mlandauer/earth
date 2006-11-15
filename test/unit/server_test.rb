require File.dirname(__FILE__) + '/../test_helper'

class ServerTest < Test::Unit::TestCase
  fixtures :servers

  def test_find_this_server
    server = Server.this_server
    assert_equal(Server.this_hostname, server.name)
    assert_equal("/foo", server.watch_directory)
  end
  
  def test_server_not_in_db
    Server.this_server.destroy
    assert_raise(RuntimeError) { Server.this_server }
  end  
end
