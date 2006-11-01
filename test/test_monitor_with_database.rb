require "fileutils"
require "monitor_with_database"
require "file_info"

class TestMonitorWithDatabase < Test::Unit::TestCase
  def setup
    @dir = File.expand_path('test_data')
    @monitor = MonitorWithDatabase.new(@dir)
    # 1st of January 2000
    @time1 = Time.local(2000, 1, 1)
    @time2 = Time.local(2001, 1, 1)
  end
  
  # Database should be empty on startup
  def test_empty
    assert(FileInfo.find_all.empty?)
  end
  
  def test_simple
    @monitor.file_added(@dir, 'file1', @time1)
    @monitor.file_added(File.join(@dir, 'dir1'), 'file1', @time2)
    files = FileInfo.find_all
    assert_equal(2, files.size)
    assert_equal(@dir, files[0].path)
    assert_equal('file1', files[0].name)
    assert_equal(@time1, files[0].modified)
    assert_equal(File.join(@dir, 'dir1'), files[1].path)
    assert_equal('file1', files[1].name)
    assert_equal(@time2, files[1].modified)
  end
  
  def test_delete
    @monitor.file_added(@dir, 'file1', @time1)
    @monitor.file_added(File.join(@dir, 'dir1'), 'file1', @time2)
    @monitor.file_removed(@dir, 'file1')
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(File.join(@dir, 'dir1'), files[0].path)    
    assert_equal('file1', files[0].name)    
  end
end
