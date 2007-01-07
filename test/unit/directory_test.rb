require File.dirname(__FILE__) + '/../test_helper'

class DirectoryTest < Test::Unit::TestCase
  fixtures :servers, :directories, :files
  set_fixture_class :servers => Earth::Server, :directories => Earth::Directory, :files => Earth::File

  def test_server
    assert_equal(servers(:first), directories(:foo_bar_twiddle).server)
  end
  
  def test_find_by_path
    assert_equal(directories(:foo), Earth::Directory.find_by_path("/foo"))
    assert_equal(directories(:foo_bar), Earth::Directory.find_by_path("/foo/bar"))
    assert_equal(directories(:foo_bar_twiddle), Earth::Directory.find_by_path("/foo/bar/twiddle"))
    assert_equal(directories(:bar), Earth::Directory.find_by_path("/bar"))
    assert_nil(Earth::Directory.find_by_path("/foo/bar/boo"))
  end
  
  def test_path
    assert_equal("/foo", directories(:foo).path)
    assert_equal("/foo/bar", directories(:foo_bar).path)
    assert_equal("/foo/bar/twiddle", directories(:foo_bar_twiddle).path)
  end
  
  def test_path_on_create
    dir = Earth::Server.this_server.directories.create(:name => "another", :parent => directories(:foo_bar))
    assert_equal("/foo/bar/another", dir.path)
    dir = Earth::Server.this_server.directories.create(:name => "/a/root/directory")
    assert_equal("/a/root/directory", dir.path)
  end
  
  # Tests an alternative interface to "move_to_child_of"
  def test_set_parent 
    assert_equal(2, directories(:foo_bar).lft)
    assert_equal(5, directories(:foo_bar).rgt)
    dir = Earth::Server.this_server.directories.create(:name => "another")
    dir.parent = directories(:foo_bar)
    dir.save
    assert_equal(directories(:foo_bar).id, dir.parent_id)
    assert_equal("/foo/bar/another", dir.path)
    assert_equal(3, dir.lft)
    assert_equal(4, dir.rgt)
    
    directories(:foo_bar).reload
    assert_equal(2, directories(:foo_bar).lft)
    assert_equal(7, directories(:foo_bar).rgt)
  end
  
  def test_set_parent_on_create
    dir = Earth::Server.this_server.directories.create(:name => "another", :parent => directories(:foo_bar))
    assert_equal(directories(:foo_bar).id, dir.parent_id)
    assert_equal(3, dir.lft)
    assert_equal(4, dir.rgt)
    
    directories(:foo_bar).reload
    assert_equal(2, directories(:foo_bar).lft)
    assert_equal(7, directories(:foo_bar).rgt)    
  end
  
  def test_name
    assert_equal("/foo", directories(:foo).name)
    assert_equal("bar", directories(:foo_bar).name)
    assert_equal("twiddle", directories(:foo_bar_twiddle).name)
  end
  
  def test_stat
    # Getting a File::Stat from a "random" file
    stat = File.lstat(File.dirname(__FILE__) + '/../test_helper.rb')
    directories(:foo).stat = stat
    assert_equal(stat.mtime, directories(:foo).modified)
    # And we should be able to read back as a stat object
    assert_equal(stat.mtime, directories(:foo).stat.mtime)
    # And we should be able to directly compare the stats even though they are different kinds of object
    assert_kind_of(File::Stat, stat)
    assert_kind_of(Earth::Directory::Stat, directories(:foo).stat)
    assert_equal(stat, directories(:foo).stat)
    assert_equal(directories(:foo).stat, stat)
  end
  
  def test_size
    assert_equal(files(:file1).size + files(:file2).size, directories(:foo).size)
    assert_equal(files(:file3).size + files(:file4).size, directories(:foo_bar).size)
    assert_equal(0, directories(:foo_bar_twiddle).size)
  end
  
  def test_recursive_size
    assert_equal(files(:file1).size + files(:file2).size + files(:file3).size + files(:file4).size,
      directories(:foo).recursive_size)
    assert_equal(files(:file3).size + files(:file4).size,
      directories(:foo_bar).recursive_size)
  end
  
  # Doing this to double-check my understanding of caching with associations in ActiveRecord
  # assert_no_queries was taken from ActiveRecord tests
  def test_association_caching
    file1 = files(:file1)
    file2 = files(:file2)
    foo = directories(:foo)
    
    assert_equal([file1, file2], foo.files)
    assert_no_queries {assert_equal([file1, file2], foo.files)}
    # Test that creating on an association like this means that the cached association gets updated too
    file3 = foo.files.create(:name => "c", :size => 3)
    assert_no_queries {assert_equal([file1, file2, file3], foo.files)}
    foo.files.delete(file2)
    assert_no_queries {assert_equal([file1, file3], foo.files)}
  end
  
  def test_child_create
    dir = directories(:foo).child_create(:name => "blah")
    assert_equal("blah", dir.name)
    assert_equal("/foo/blah", dir.path)
    assert_equal(directories(:foo), dir.parent)
    assert_equal(1, dir.server_id)
    assert_equal([dir, directories(:foo_bar)], directories(:foo).children)
  end

  def test_children
    foo = directories(:foo)
    foo_bar = directories(:foo_bar)
    
    assert_equal([foo_bar], foo.children)
    assert_no_queries{assert_equal([foo_bar], foo.children)}
    
    foo_fiddle = foo.child_create(:name => "fiddle")
    assert_no_queries{assert_equal([foo_fiddle, foo_bar], foo.children)}
    # Force a reload of children and check that the values are correct too
    assert_queries(1){assert_equal([foo_fiddle, foo_bar], foo.children(true))}
    foo.child_delete(foo_bar)
    assert_no_queries{assert_equal([foo_fiddle], foo.children)}
    assert_queries(1){assert_equal([foo_fiddle], foo.children(true))}
  end
  
  def test_load_all_children
    foo = directories(:foo)
    foo_bar = directories(:foo_bar)
    foo_bar_twiddle = directories(:foo_bar_twiddle)

    assert_queries(1) {foo.load_all_children}
    assert_no_queries{assert_equal([foo_bar], foo.children)}
    assert_no_queries{assert_equal([foo_bar_twiddle], foo.children[0].children)}
    assert_no_queries{assert_equal([], foo.children[0].children[0].children)}
  end
  
  def test_each
    a = []
    directories(:foo).each {|x| a << x.path}
    # We should move from the leaves to the root
    assert_equal(["/foo/bar/twiddle", "/foo/bar", "/foo"], a)
  end
  
  def test_update
    foo = directories(:foo)
    assert_equal(1, foo.lft)
    assert_equal(6, foo.rgt)
    foo_bar = directories(:foo_bar)
    # This will update the lft and rgt values of foo in the database (but not in the loaded object)
    foo_bar.child_create(:name => "wibble")
    assert_equal(1, foo.lft)
    assert_equal(6, foo.rgt)
    foo.name = 'name'
    foo.modified = Time.at(0)
    foo.update
    
    foo.reload
    assert_equal('name', foo.name)
    assert_equal(Time.at(0), foo.modified)
    assert_equal(1, foo.lft)
    assert_equal(8, foo.rgt)
  end
  
  # Test that deleting a directory (which also deletes all directories below it) also deletes
  # all associated files
  def test_destroy
    directories(:foo).destroy
    assert_equal([directories(:bar)], Earth::Directory.find(:all))
    assert_equal([], Earth::File.find(:all))
  end
  
end

class TransactionalDirectoryTest < Test::Unit::TestCase
  fixtures :servers, :directories, :files
  set_fixture_class :servers => Earth::Server, :directories => Earth::Directory, :files => Earth::File
  self.use_transactional_fixtures = false
  
  def setup
    @allow_concurrency = ActiveRecord::Base.allow_concurrency
    ActiveRecord::Base.allow_concurrency = true
  end
  
  def teardown
    ActiveRecord::Base.allow_concurrency = @allow_concurrency
  end
  
  # Test that when we are calculating the size of a directory and the daemon is updating
  # the DB at the same time, that we get consistent results from the Directory.find to the
  # Directory.size
  def test_concurrency
    reader = Thread.new do
      10.times do
        Earth::Directory.transaction do
          foo_bar = Earth::Directory.find(2) # => /foo/bar
          sleep(0.01)
          assert_equal(7, foo_bar.recursive_size)
        end
      end
    end
    writer = Thread.new do
      (1..10).each { |i|
        Earth::Directory.find(1).child_create(:name => "bruno#{i}") # => /foo/bruno#{counter}
        }
      end

      reader.join
      writer.join
  end
  
end