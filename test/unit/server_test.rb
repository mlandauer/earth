require File.dirname(__FILE__) + '/../test_helper'

class ServerTest < Test::Unit::TestCase
  fixtures :servers

  def test_find_this_server
    Server.create(:name => Socket.gethostname, :watch_directory => "/foo")
    Server.create(:name => "foo", :watch_directory => "/bar")
    server = Server.find_this_server
    assert_equal(Socket.gethostname, server.name)
    assert_equal("/foo", server.watch_directory)
  end
end
