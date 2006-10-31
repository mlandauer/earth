require "monitor.rb"
require "fileutils.rb"

class TestMonitor < Test::Unit::TestCase
  def setup
    # Put some test files in the directory test_data
    FileUtils.rm_rf 'test_data'
    FileUtils.mkdir_p 'test_data/dir1'
    FileUtils.touch 'test_data/file1'
    FileUtils.touch 'test_data/dir1/file1'

    @monitor = MonitorWithQueue.new("test_data")
  end
  
  def teardown
    # Tidy up
    FileUtils.rm_rf 'test_data'
  end

  def test_empty    
    assert(!@monitor.exist?('test_data/file1'))
    assert(!@monitor.exist?('test_data/file2'))
  end
  
  def test_update
     # It should only update its knowledge of the files on calling update
    @monitor.update
    assert(@monitor.exist?('test_data/file1'))
    assert(!@monitor.exist?('test_data/file2'))    
  end
  
  # Those pesky '.' and '..' directories shouldn't be there
  def test_hidden_files
    @monitor.update
    assert(!@monitor.exist?('test_data/.')) 
    assert(!@monitor.exist?('test_data/..')) 
  end
  
  def test_recursive
    @monitor.update
    assert(@monitor.exist?('test_data/dir1/file1'))
    assert(!@monitor.exist?('test_data/dir1/file2'))
  end
  
  def test_added
    @monitor.queue.clear
    @monitor.update
    assert_equal(FileAdded.new('test_data/file1'), @monitor.queue.pop)
    assert_equal(FileAdded.new('test_data/dir1/file1'), @monitor.queue.pop)
    assert(@monitor.queue.empty?)
  end
  
  def test_removed
    @monitor.update
    FileUtils.rm_rf 'test_data/dir1'
    FileUtils.rm 'test_data/file1'
    @monitor.queue.clear
    @monitor.update
    assert_equal(FileRemoved.new('test_data/file1'), @monitor.queue.pop)
    assert_equal(FileRemoved.new('test_data/dir1/file1'), @monitor.queue.pop)
    assert(@monitor.queue.empty?)
  end
  
  def test_removed2
    FileUtils.mkdir 'test_data/dir1/dir2'
    FileUtils.touch 'test_data/dir1/dir2/file'
    @monitor.update
    FileUtils.rm_rf 'test_data/dir1'
    @monitor.queue.clear
    @monitor.update
    assert_equal(FileRemoved.new('test_data/dir1/file1'), @monitor.queue.pop)
    assert_equal(FileRemoved.new('test_data/dir1/dir2/file'), @monitor.queue.pop)
    assert(@monitor.queue.empty?)
  end

  def test_change_in_subdirectory
    @monitor.update
    FileUtils.touch 'test_data/dir1/file2'
    @monitor.queue.clear
    @monitor.update
    assert_equal(FileAdded.new('test_data/dir1/file2'), @monitor.queue.pop)
    assert(@monitor.queue.empty?)
  end
  
end
