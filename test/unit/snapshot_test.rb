class SnapshotTest < Test::Unit::TestCase
  def setup
    @dir = File.expand_path('test_data')
    @file2 = File.join(@dir, 'file1')
    @dir2 = File.join(@dir, 'dir2')

    FileUtils.rm_rf @dir
    FileUtils.mkdir @dir
    FileUtils.touch @file2
    FileUtils.mkdir @dir2
    
    @queue = FileMonitorQueue.new
    @monitor = Snapshot.new(@queue, @queue.directory_added(@dir, File.lstat(@dir)))
    @queue.clear
  end

  def teardown
    FileUtils.rm_rf @dir
  end
  
  def test_simple
    @monitor.update
    assert_equal(FileMonitorQueue::DirectoryAdded.new(@dir2, nil), @queue.pop)
    assert_equal(FileMonitorQueue::FileAdded.new(@dir, 'file1', File.lstat(@file2)), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryChanged.new(@dir, File.lstat(@dir)), @queue.pop)
    assert(@queue.empty?)
  end
  
  def test_removed_watched_directory
    @monitor.update
    FileUtils.rm_rf @dir
    @queue.clear
    @monitor.update
    
    assert_equal(FileMonitorQueue::FileRemoved.new(@dir, 'file1'), @queue.pop)
    assert_equal(FileMonitorQueue::DirectoryRemoved.new(@dir2), @queue.pop)
    assert(@queue.empty?)
  end
end
