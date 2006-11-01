require "fileutils"
require "monitor_with_database"
require "file_info"

class TestMonitorWithDatabase < Test::Unit::TestCase
  def setup
    @dir = File.expand_path('test_data')
    @monitor = MonitorWithDatabase.new(@dir)
  end
  
  # Database should be empty on startup
  def test_empty
    assert(FileInfo.find_all.empty?)
  end
  
  def test_simple
    @monitor.file_added(@dir, 'file1')
    @monitor.file_added(File.join(@dir, 'dir1'), 'file1')
    files = FileInfo.find_all
    assert_equal(2, files.size)
    assert_equal(@dir, files[0].path)
    assert_equal('file1', files[0].name)
    assert_equal(File.join(@dir, 'dir1'), files[1].path)
    assert_equal('file1', files[1].name)
  end
  
  def test_delete
    @monitor.file_added(@dir, 'file1')
    @monitor.file_added(File.join(@dir, 'dir1'), 'file1')
    @monitor.file_removed(@dir, 'file1')
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(File.join(@dir, 'dir1'), files[0].path)    
    assert_equal('file1', files[0].name)    
  end
end
