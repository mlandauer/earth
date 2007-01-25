require File.dirname(__FILE__) + '/../test_helper'

class ServerTest < Test::Unit::TestCase
  fixtures :servers, :directories, :files
  set_fixture_class :directories => Earth::Directory, :servers => Earth::Server

  def test_this_server
    server = Earth::Server.this_server
    assert_equal(Earth::Server.this_hostname, server.name)
    assert_equal([directories(:foo), 
                  directories(:foo_bar), 
                  directories(:foo_bar_twiddle), 
                  directories(:foo_bar_twiddle_frob), 
                  directories(:foo_bar_twiddle_frob_baz)], server.directories)
  end
  
  def test_server_not_in_db
    Earth::Server.this_server.destroy
    # Should create a server record if it doesn't already exist
    server = Earth::Server.this_server
    assert_equal(Earth::Server.this_hostname, server.name)
  end
  
  def test_delete_all_directories_on_this_server
    Earth::Server.this_server.destroy
    directories = Earth::Directory.find(:all)
    assert_equal(2, directories.size)
    assert_equal([directories(:fizzle), directories(:bar)], directories)
    files = Earth::File.find(:all)
    assert_equal(4, files.size)
  end
  
  def test_recursive_file_count
    assert_equal(6, servers(:first).recursive_file_count)
    assert_equal(0, servers(:another).recursive_file_count)
    assert_equal(4, servers(:yet_another).recursive_file_count)
  end
  
  def test_has_files
    assert(servers(:first).has_files?)
    assert(!servers(:another).has_files?)
    assert(servers(:yet_another).has_files?)
  end
end
