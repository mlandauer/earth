require "fileutils"
require "monitor_with_database"
require "file_info"

class TestMonitorWithDatabase < Test::Unit::TestCase
  def setup
    # Put some test files in the directory test_data
    FileUtils.rm_rf 'test_data'
    FileUtils.mkdir_p 'test_data/dir1'
    FileUtils.touch 'test_data/file1'
    FileUtils.touch 'test_data/dir1/file1'

    @monitor = MonitorWithDatabase.new("test_data")
  end
  
  def teardown
    # Tidy up
    FileUtils.rm_rf 'test_data'
  end

  # Database should be empty on startup
  def test_empty
    assert(FileInfo.find_all.empty?)
  end
  
  def test_simple
    @monitor.update
    files = FileInfo.find_all
    assert_equal(2, files.size)
    assert_equal(File.expand_path('test_data/file1'), files[0].path)
    assert_equal(File.expand_path('test_data/dir1/file1'), files[1].path)
  end
  
  def test_delete
    @monitor.update
    FileUtils.rm 'test_data/file1'
    @monitor.update
    files = FileInfo.find_all
    assert_equal(1, files.size)
    assert_equal(File.expand_path('test_data/dir1/file1'), files[0].path)    
  end
end
