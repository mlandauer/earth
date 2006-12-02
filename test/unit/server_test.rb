require File.dirname(__FILE__) + '/../test_helper'

class ServerTest < Test::Unit::TestCase
  fixtures :directories, :servers, :file_info

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
  
  def test_delete_all_directories
    Server.this_server.destroy
    directories = Directory.find_all
    assert_equal(1, directories.size)
    assert_equal(directories(:bar), directories[0])
    files = FileInfo.find_all
    assert_equal(0, files.size)
  end
end
