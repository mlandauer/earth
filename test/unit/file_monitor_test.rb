# By mixing in these tests, we can run these test for all classes
# derived from FileMonitor
module FileMonitorTest
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
    @monitor = file_monitor(@queue.directory_added(nil, @dir), @queue)
  end
  
  def teardown
    # Tidy up
    File.chmod(0777, @dir1) if File.exist?(@dir1)
    FileUtils.rm_rf 'test_data'
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
    directories = Directory.find_all
    assert_equal(2, directories.size)
    assert_equal(@dir, directories[0].path)
    assert_equal(File.lstat(@dir), directories[0].stat)
    assert_equal(@dir1, directories[1].path)
    assert_equal(File.lstat(@dir1), directories[1].stat)
    
    files = FileInfo.find_all
    assert_equal(2, files.size)
    assert_equal(@dir1, files[0].directory.path)
    assert_equal('file1', files[0].name)
    assert_equal(File.lstat(@file2), files[0].stat)
    assert_equal(@dir, files[1].directory.path)
    assert_equal('file1', files[1].name)
    assert_equal(File.lstat(@file1), files[1].stat)
  end

  def test_removed
    @monitor.update
    FileUtils.rm_rf 'test_data/dir1'
    FileUtils.rm 'test_data/file1'
    @monitor.update
    
    directories = Directory.find_all
    assert_equal(1, directories.size)
    assert_equal(@dir, directories[0].path)
    assert_equal(File.lstat(@dir), directories[0].stat)

    files = FileInfo.find_all
    assert_equal(0, files.size)
  end

  def test_removed2
    dir2 = File.join(@dir1, 'dir2')
    
    FileUtils.mkdir dir2
    FileUtils.touch File.join(dir2, 'file')
    @monitor.update
    FileUtils.rm_rf @dir1
    @monitor.update
    
    directories = Directory.find_all
    assert_equal(1, directories.size)
    assert_equal(@dir, directories[0].path)
    assert_equal(File.lstat(@dir), directories[0].stat)

    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(@dir, files[0].directory.path)
    assert_equal('file1', files[0].name)
    assert_equal(File.lstat(@file1), files[0].stat)
  end
  
  def test_changed
    @monitor.update
    FileUtils.touch @file2
    # For the previous change to be noticed we need to create a new file as well
    # This is only strictly true for the PosixFileMonitor
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    @monitor.update
    
    directories = Directory.find_all
    assert_equal(2, directories.size)
    assert_equal(@dir, directories[0].path)
    assert_equal(File.lstat(@dir), directories[0].stat)
    assert_equal(@dir1, directories[1].path)
    assert_equal(File.lstat(@dir1), directories[1].stat)

    files = FileInfo.find_all
    assert_equal(3, files.size)
    assert_equal(@dir1, files[0].directory.path)
    assert_equal('file1', files[0].name)
    assert_equal(File.lstat(@file2), files[0].stat)
    assert_equal(@dir, files[1].directory.path)
    assert_equal('file1', files[1].name)
    assert_equal(File.lstat(@file1), files[1].stat)
    assert_equal(@dir1, files[2].directory.path)
    assert_equal('file2', files[2].name)
    assert_equal(File.lstat(file3), files[2].stat)
  end
  
  def test_added_in_subdirectory
    @monitor.update
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    @monitor.update
    
    directories = Directory.find_all
    assert_equal(2, directories.size)
    assert_equal(@dir, directories[0].path)
    assert_equal(File.lstat(@dir), directories[0].stat)
    assert_equal(@dir1, directories[1].path)
    assert_equal(File.lstat(@dir1), directories[1].stat)
    files = FileInfo.find_all
    assert_equal(3, files.size)
    assert_equal(@dir1, files[0].directory.path)
    assert_equal('file1', files[0].name)
    assert_equal(File.lstat(@file2), files[0].stat)
    assert_equal(@dir, files[1].directory.path)
    assert_equal('file1', files[1].name)
    assert_equal(File.lstat(@file1), files[1].stat)
    assert_equal(@dir1, files[2].directory.path)
    assert_equal('file2', files[2].name)
    assert_equal(File.lstat(file3), files[2].stat)
  end

  # If the daemon doesn't have permission to list the directory
  # it should ignore it
  def test_permissions_directory
    # Remove all permission from directory
    mode = File.stat(@dir1).mode
    File.chmod(0000, @dir1)
    @monitor.update
    
    directories = Directory.find_all
    assert_equal(2, directories.size)
    assert_equal(@dir, directories[0].path)
    assert_equal(File.lstat(@dir), directories[0].stat)
    assert_equal(@dir1, directories[1].path)
    assert_equal(File.lstat(@dir1), directories[1].stat)
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(@dir, files[0].directory.path)
    assert_equal('file1', files[0].name)
    assert_equal(File.lstat(@file1), files[0].stat)

    # Add permissions back
    File.chmod(mode, @dir1)
  end
end

class PosixFileMonitorTest < Test::Unit::TestCase
  include FileMonitorTest

  # Factory method
  def file_monitor(directory, queue)
    PosixFileMonitor.new(directory, queue)
  end
end
