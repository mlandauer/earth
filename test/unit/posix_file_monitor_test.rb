class PosixFileMonitorTest < Test::Unit::TestCase
  def setup
    # Put some test files in the directory test_data
    @relative_dir = 'test_data'
    @dir = File.expand_path(@relative_dir)
    @file1 = File.join(@dir, 'file1')
    @dir1 = File.join(@dir, 'dir1')
    @file2 = File.join(@dir1, 'file1')

    FileUtils.rm_rf @dir
    FileUtils.mkdir_p @dir1
    FileUtils.touch @file1
    FileUtils.touch @file2
    
    # Changes the access and modification time to be one minute in the past
    past = Time.now - 60
    File.utime(past, past, @dir)
    File.utime(past, past, @dir1)
    File.utime(past, past, @file1)
    File.utime(past, past, @file2)
    
    # Clears the contents of the database
    FileInfo.delete_all
    Directory.delete_all

    @queue = FileDatabaseUpdater.new
    @monitor = PosixFileMonitor.new(@queue.directory_added(nil, @dir), @queue)
  end
  
  def teardown
    # Tidy up
    File.chmod(0777, @dir1) if File.exist?(@dir1)
    FileUtils.rm_rf 'test_data'
  end
  
  # Compare directory object with a directory on the filesystem
  def assert_directory(path, directory)
    assert_equal(path, directory.path)
    assert_equal(File.lstat(path), directory.stat)  
  end
  
  # Compare file object with a file on the filesystem
  def assert_file(path, file)
    assert_equal(File.dirname(path), file.directory.path)
    assert_equal(File.basename(path), file.name)
    assert_equal(File.lstat(path), file.stat)
  end

  def assert_directories(paths, directories)
    assert_equal(paths.size, directories.size)
    paths.each_index{|i| assert_directory(paths[i], directories[i])}
  end
  
  def assert_files(paths, files)
    assert_equal(paths.size, files.size)
    paths.each_index{|i| assert_file(paths[i], files[i])}
  end
  
  def test_ignore_dot_files
    FileUtils.touch 'test_data/.an_invisible_file'
    FileUtils.touch 'test_data/.another'
    @monitor.update    
    assert_nil(FileInfo.find_by_name('.an_invisible_file'))
    assert_nil(FileInfo.find_by_name('.another'))
  end
  
  def test_added
    @monitor.update
    assert_directories([@dir, @dir1], Directory.find_all)
    assert_files([@file2, @file1], FileInfo.find_all)
  end

  def test_removed
    @monitor.update
    FileUtils.rm_rf 'test_data/dir1'
    FileUtils.rm 'test_data/file1'
    @monitor.update
    
    assert_directories([@dir], Directory.find_all)
    assert_files([], FileInfo.find_all)
  end

  def test_removed2
    dir2 = File.join(@dir1, 'dir2')
    
    FileUtils.mkdir dir2
    FileUtils.touch File.join(dir2, 'file')
    @monitor.update
    FileUtils.rm_rf @dir1
    @monitor.update
    
    assert_directories([@dir], Directory.find_all)
    assert_files([@file1], FileInfo.find_all)
  end
  
  def test_changed
    @monitor.update
    FileUtils.touch @file2
    # For the previous change to be noticed we need to create a new file as well
    # This is only strictly true for the PosixFileMonitor
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    @monitor.update
    
    assert_directories([@dir, @dir1], Directory.find_all)
    assert_files([@file2, @file1, file3], FileInfo.find_all)
  end
  
  def test_added_in_subdirectory
    @monitor.update
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    @monitor.update
    
    assert_directories([@dir, @dir1], Directory.find_all)
    assert_files([@file2, @file1, file3], FileInfo.find_all)
  end

  # If the daemon doesn't have permission to list the directory
  # it should ignore it
  def test_permissions_directory
    # Remove all permission from directory
    mode = File.stat(@dir1).mode
    File.chmod(0000, @dir1)
    @monitor.update
    
    assert_directories([@dir, @dir1], Directory.find_all)
    assert_files([@file1], FileInfo.find_all)

    # Add permissions back
    File.chmod(mode, @dir1)
  end
end
