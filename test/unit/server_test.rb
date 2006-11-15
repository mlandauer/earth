require File.dirname(__FILE__) + '/../test_helper'

class ServerTest < Test::Unit::TestCase
  fixtures :servers

  def test_find_this_server
    Server.create(:name => Server.this_hostname, :watch_directory => "/foo")
    Server.create(:name => "foo", :watch_directory => "/bar")
    server = Server.this_server
    assert_equal(Socket.gethostname, server.name)
    assert_equal("/foo", server.watch_directory)
  end
  
  def test_server_not_in_db
    Server.create(:name => "foo", :watch_directory => "/bar")
    # This test assumes that you wouldn't call your machine foo!
    assert_raise(RuntimeError) { Server.this_server }
  end  
end
