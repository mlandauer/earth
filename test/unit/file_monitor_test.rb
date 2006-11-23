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
    
    @queue = FileMonitorQueue.new
    # By passing the relative path we are ensuring that the 
    # translation to absolute path happens
    @monitor = file_monitor(@relative_dir, @queue)
  end
  
  def teardown
    # Tidy up
    File.chmod(0777, @dir1) if File.exist?(@dir1)
    FileUtils.rm_rf 'test_data'
  end
  
  def test_ignore_dot_files
    @monitor.update
    FileUtils.touch 'test_data/.an_invisible_file'
    FileUtils.touch 'test_data/.another'
    @queue.clear
    @monitor.update
    assert_equal(FileMonitorQueue::DirectoryChanged.new(@dir, File.lstat(@dir)), @queue.pop)
    assert(@queue.empty?)
  end
  
  def test_added
    @monitor.update
    # The directory added message needs to appear before the file added message
    assert_equal(FileMonitorQueue::DirectoryAdded.new(@dir), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryAdded.new(@dir1), @queue.pop)
    # Files added deep inside the directory structure should occur before those higher up
    assert_equal(FileMonitorQueue::FileAdded.new(@dir1, 'file1', File.lstat(@file2)), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryChanged.new(@dir1, File.lstat(@dir1)), @queue.pop)
    assert_equal(FileMonitorQueue::FileAdded.new(@dir, 'file1', File.lstat(@file1)), @queue.pop)
    # Updates the modified time of the directory at the end
    assert_equal(FileMonitorQueue::DirectoryChanged.new(@dir, File.lstat(@dir)), @queue.pop)
    assert(@queue.empty?)
  end

  def test_removed
    @monitor.update
    FileUtils.rm_rf 'test_data/dir1'
    FileUtils.rm 'test_data/file1'
    @queue.clear
    @monitor.update
    
    # Starts with deepest directory
    assert_equal(FileMonitorQueue::FileRemoved.new(@dir1, 'file1'), @queue.pop)
    assert_equal(FileMonitorQueue::FileRemoved.new(@dir, 'file1'), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryRemoved.new(@dir1), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryChanged.new(@dir, File.lstat(@dir)), @queue.pop)
    assert(@queue.empty?)
  end

  def test_removed2
    dir2 = File.join(@dir1, 'dir2')
    
    FileUtils.mkdir dir2
    FileUtils.touch File.join(dir2, 'file')
    @monitor.update
    FileUtils.rm_rf @dir1
    @queue.clear
    @monitor.update
    
    # Starts with the deepest directory
    assert_equal(FileMonitorQueue::FileRemoved.new(dir2, 'file'), @queue.pop)
    assert_equal(FileMonitorQueue::FileRemoved.new(@dir1, 'file1'), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryRemoved.new(dir2), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryRemoved.new(@dir1), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryChanged.new(@dir, File.lstat(@dir)), @queue.pop)
    assert(@queue.empty?)
  end
  
  def test_changed
    @monitor.update
    FileUtils.touch @file2
    # For the previous change to be noticed we need to create a new file as well
    # This is only strictly true for the PosixFileMonitor
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    @queue.clear
    @monitor.update
    # Currently "changed" messages appear before "added" messages
    assert_equal(FileMonitorQueue::FileChanged.new(@dir1, 'file1', File.lstat(@file2)), @queue.pop)
    assert_equal(FileMonitorQueue::FileAdded.new(@dir1, 'file2', File.lstat(file3)), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryChanged.new(@dir1, File.lstat(@dir1)), @queue.pop)
    assert(@queue.empty?)
  end
  
  def test_added_in_subdirectory
    @monitor.update
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    @queue.clear
    @monitor.update
    assert_equal(FileMonitorQueue::FileAdded.new(@dir1, 'file2', File.lstat(file3)), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryChanged.new(@dir1, File.lstat(@dir1)), @queue.pop)
    assert(@queue.empty?)
  end

  # If the daemon doesn't have permission to list the directory
  # it should ignore it
  def test_permissions_directory
    # Remove all permission from directory
    mode = File.stat(@dir1).mode
    @queue.clear
    File.chmod(0000, @dir1)
    @monitor.update
    assert_equal(FileMonitorQueue::DirectoryAdded.new(@dir1), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryChanged.new(@dir1, File.lstat(@dir1)), @queue.pop)
    assert_equal(FileMonitorQueue::FileAdded.new(@dir, 'file1', File.lstat(@file1)), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryChanged.new(@dir, File.lstat(@dir)), @queue.pop)
    assert(@queue.empty?)
    # Add permissions back
    File.chmod(mode, @dir1)
  end
end

class PosixFileMonitorTest < Test::Unit::TestCase
  include FileMonitorTest

  # Factory method
  def file_monitor(dir, queue)
    PosixFileMonitor.new(dir, queue)
  end
end
