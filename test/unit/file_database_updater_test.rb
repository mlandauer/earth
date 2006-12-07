class FileDatabaseUpdaterTest < Test::Unit::TestCase
  # Duck typing comes in handy here. Making fake File::Stat object
  Stat = Struct.new(:mtime, :size, :uid, :gid)

  def setup
    # Clears the contents of the database
    Server.delete_all
    FileInfo.delete_all
    Directory.delete_all

    @dir = File.expand_path('test_data')
    @dir1 = File.join(@dir, 'dir1')
    @updater = FileDatabaseUpdater.new(Server.this_server)
    # 1st of January 2000
    @stat1 = Stat.new(Time.local(2000, 1, 1), 24, 100, 200)
    @stat2 = Stat.new(Time.local(2001, 1, 1), 53, 100, 200)
  end
  
  def test_file_added_signature
    f = @updater.file_added(@updater.directory_added(nil, @dir), 'file1', @stat1)
    assert_equal(@dir, f.directory.path)
    assert_equal('file1', f.name)
    assert_equal(@stat1.mtime, f.stat.mtime)
    assert_equal(@stat1.size, f.stat.size)
    assert_equal(@stat1.uid, f.stat.uid)
    assert_equal(@stat1.gid, f.stat.gid)
  end
  
  def test_file_removed_signature
    dir = @updater.directory_added(nil, @dir)
    file = @updater.file_added(dir, 'file1', @stat1)
    @updater.file_removed(file)
  end
  
  def test_file_changed_signature
    dir = @updater.directory_added(nil, @dir)
    file = @updater.file_added(dir, 'file1', @stat1)
    @updater.file_changed(file, @stat2)
  end

  # When we call add_directory it should return a directory object
  def test_directory_added_signature
    d = @updater.directory_added(nil, @dir)
    assert_equal(@dir, d.path)
    assert_nil(d.stat)
    d2 = @updater.directory_added(d, 'dir1')
    assert_equal(@dir1, d2.path)
    assert_nil(d2.stat)
  end
  
  def test_directory_removed_signature
    @updater.directory_removed(@updater.directory_added(nil, @dir))
  end
  
  def test_directory_changed_signature
    dir = @updater.directory_added(nil, @dir)
    @updater.directory_changed(dir, @stat2)
    assert_equal(@stat2.mtime, dir.stat.mtime)
  end

  # Database should be empty on startup
  def test_empty
    assert_equal(0, FileInfo.count)
    assert_equal(0, Directory.count)
  end
  
  def test_simple
    dir = @updater.directory_added(nil, @dir)
    @updater.file_added(dir, 'file1', @stat1)
    dir1 = @updater.directory_added(dir, 'dir1')
    @updater.file_added(dir1, 'file1', @stat2)
    files = FileInfo.find_all
    assert_equal(2, files.size)
    assert_equal(@dir, files[0].directory.path)
    assert_equal('file1', files[0].name)
    assert_equal(@stat1.mtime, files[0].stat.mtime)
    assert_equal(@stat1.size, files[0].stat.size)
    assert_equal(@dir1, files[1].directory.path)
    assert_equal('file1', files[1].name)
    assert_equal(@stat2.mtime, files[1].stat.mtime)
    assert_equal(@stat2.size, files[1].stat.size)
  end
  
  def test_add_directory
    dir = @updater.directory_added(nil, @dir)
    @updater.directory_added(dir, 'dir1')
    directories = Directory.find_all
    assert_equal(2, directories.size)
    assert_equal(@dir, directories[0].path)
    # When a directory is created it should have an invalid modification time
    assert_nil(directories[0].stat)
    assert_equal(@dir1, directories[1].path)
    assert_nil(directories[1].stat)
  end
  
  def test_server
    @updater.directory_added(nil, @dir)
    directories = Directory.find_all
    assert_equal(1, directories.size)
    assert_equal(Server.this_server, directories[0].server)
  end
  
  def test_remove_directory
    dir = @updater.directory_added(nil, @dir)
    dir1 = @updater.directory_added(dir, 'dir1')
    @updater.directory_removed(dir1)
    directories = Directory.find_all
    assert_equal(1, directories.size)
    assert_equal(@dir, directories[0].path)
  end
  
  def test_delete
    dir = @updater.directory_added(nil, @dir)
    file1 = @updater.file_added(dir, 'file1', @stat1)
    dir1 = @updater.directory_added(dir, 'dir1')
    @updater.file_added(dir1, 'file1', @stat2)
    @updater.file_removed(file1)
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(@dir1, files[0].directory.path)    
    assert_equal('file1', files[0].name)    
  end
  
  def test_change
    dir = @updater.directory_added(nil, @dir)
    file = @updater.file_added(dir, 'file1', @stat1)
    @updater.file_changed(file, @stat2)
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(@dir, files[0].directory.path)    
    assert_equal('file1', files[0].name)    
    assert_equal(@stat2.mtime, files[0].stat.mtime)
    assert_equal(@stat2.size, files[0].stat.size)
  end
  
  def test_change_directory
    dir = @updater.directory_added(nil, @dir)
    @updater.directory_changed(dir, @stat2)
    directories = Directory.find_all
    assert_equal(1, directories.size)
    assert_equal(@dir, directories[0].path)
    assert_equal(@stat2.mtime, directories[0].stat.mtime)
  end
  
  def test_ownership
    dir = @updater.directory_added(nil, @dir)
    @updater.file_added(dir, 'file1', @stat1)
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(@stat1.uid, files[0].stat.uid)
    assert_equal(@stat1.gid, files[0].stat.gid)
  end
end
