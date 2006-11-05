require "fileutils"
require "monitor_with_database"
require "file_info"

class TestMonitorWithDatabase < Test::Unit::TestCase
  # Duck typing comes in handy here. Making fake File::Stat object
  Stat = Struct.new(:mtime, :size)

  def setup
    @dir = File.expand_path('test_data')
    @monitor = MonitorWithDatabase.new
    # 1st of January 2000
    @stat1 = Stat.new(Time.local(2000, 1, 1), 24)
    @stat2 = Stat.new(Time.local(2001, 1, 1), 53)
  end
  
  # Database should be empty on startup
  def test_empty
    assert(FileInfo.find_all.empty?)
  end
  
  def test_simple
    @monitor.file_added(@dir, 'file1', @stat1)
    @monitor.file_added(File.join(@dir, 'dir1'), 'file1', @stat2)
    files = FileInfo.find_all
    assert_equal(2, files.size)
    assert_equal(@dir, files[0].path)
    assert_equal('file1', files[0].name)
    assert_equal(@stat1.mtime, files[0].modified)
    assert_equal(@stat1.size, files[0].size)
    assert_equal(File.join(@dir, 'dir1'), files[1].path)
    assert_equal('file1', files[1].name)
    assert_equal(@stat2.mtime, files[1].modified)
    assert_equal(@stat2.size, files[1].size)
  end
  
  def test_delete
    @monitor.file_added(@dir, 'file1', @stat1)
    @monitor.file_added(File.join(@dir, 'dir1'), 'file1', @stat2)
    @monitor.file_removed(@dir, 'file1')
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(File.join(@dir, 'dir1'), files[0].path)    
    assert_equal('file1', files[0].name)    
  end
  
  def test_change
    @monitor.file_added(@dir, 'file1', @stat1)
    @monitor.file_changed(@dir, 'file1', @stat2)
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(@dir, files[0].path)    
    assert_equal('file1', files[0].name)    
    assert_equal(@stat2.mtime, files[0].modified)
    assert_equal(@stat2.size, files[0].size)
  end
end
