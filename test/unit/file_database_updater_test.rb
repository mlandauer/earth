class FileDatabaseUpdaterTest < Test::Unit::TestCase
  # Duck typing comes in handy here. Making fake File::Stat object
  Stat = Struct.new(:mtime, :size, :uid, :gid)

  def setup
    @dir = File.expand_path('test_data')
    @dir1 = File.join(@dir, 'dir1')
    @updater = FileDatabaseUpdater.new
    # 1st of January 2000
    @stat1 = Stat.new(Time.local(2000, 1, 1), 24, 100, 200)
    @stat2 = Stat.new(Time.local(2001, 1, 1), 53, 100, 200)
  end
  
  # When we call add_directory it should return a directory object
  def test_add_directory_returned_value
    d = @updater.directory_added(@dir)
    assert_equal(@dir, d.path)
  end

  # Database should be empty on startup
  def test_empty
    assert_equal(0, FileInfo.count)
    assert_equal(0, DirectoryInfo.count)
  end
  
  def test_simple
    dir = @updater.directory_added(@dir)
    @updater.file_added(dir, 'file1', @stat1)
    dir1 = @updater.directory_added(@dir1)
    @updater.file_added(dir1, 'file1', @stat2)
    files = FileInfo.find_all
    assert_equal(2, files.size)
    assert_equal(@dir, files[0].directory_info.path)
    assert_equal('file1', files[0].name)
    assert_equal(@stat1.mtime, files[0].modified)
    assert_equal(@stat1.size, files[0].size)
    assert_equal(@dir1, files[1].directory_info.path)
    assert_equal('file1', files[1].name)
    assert_equal(@stat2.mtime, files[1].modified)
    assert_equal(@stat2.size, files[1].size)
  end
  
  def test_add_directory
    @updater.directory_added(@dir)
    @updater.directory_added(@dir1)
    directories = DirectoryInfo.find_all
    assert_equal(2, directories.size)
    assert_equal(@dir, directories[0].path)
    assert_equal(@dir1, directories[1].path)
  end
  
  def test_remove_directory
    @updater.directory_added(@dir)
    dir1 = @updater.directory_added(@dir1)
    @updater.directory_removed(dir1)
    directories = DirectoryInfo.find_all
    assert_equal(1, directories.size)
    assert_equal(@dir, directories[0].path)
  end
  
  def test_delete
    dir = @updater.directory_added(@dir)
    @updater.file_added(dir, 'file1', @stat1)
    dir1 = @updater.directory_added(@dir1)
    @updater.file_added(dir1, 'file1', @stat2)
    @updater.file_removed(dir, 'file1')
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(File.join(@dir, 'dir1'), files[0].directory_info.path)    
    assert_equal('file1', files[0].name)    
  end
  
  def test_change
    dir = @updater.directory_added(@dir)
    @updater.file_added(dir, 'file1', @stat1)
    @updater.file_changed(dir, 'file1', @stat2)
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(@dir, files[0].directory_info.path)    
    assert_equal('file1', files[0].name)    
    assert_equal(@stat2.mtime, files[0].modified)
    assert_equal(@stat2.size, files[0].size)
  end
  
  def test_machine_name
    dir = @updater.directory_added(@dir)
    @updater.file_added(dir, 'file1', @stat1)
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(Socket::gethostname, files[0].directory_info.server)
  end
  
  def test_ownership
    dir = @updater.directory_added(@dir)
    @updater.file_added(dir, 'file1', @stat1)
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(@stat1.uid, files[0].uid)
    assert_equal(@stat1.gid, files[0].gid)
  end
end
