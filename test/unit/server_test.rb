require File.dirname(__FILE__) + '/../test_helper'

class ServerTest < Test::Unit::TestCase
  fixtures :directories, :servers, :files
  set_fixture_class :directories => Earth::Directory

  def test_this_server
    server = Earth::Server.this_server
    assert_equal(Earth::Server.this_hostname, server.name)
    assert_equal([directories(:foo), directories(:foo_bar), directories(:foo_bar_twiddle)], server.directories)
  end
  
  def test_server_not_in_db
    Earth::Server.this_server.destroy
    # Should create a server record if it doesn't already exist
    server = Earth::Server.this_server
    assert_equal(Earth::Server.this_hostname, server.name)
  end
  
  def test_delete_all_directories
    Earth::Server.this_server.destroy
    directories = Earth::Directory.find(:all)
    assert_equal(1, directories.size)
    assert_equal(directories(:bar), directories[0])
    files = Earth::File.find(:all)
    assert_equal(0, files.size)
  end
end
