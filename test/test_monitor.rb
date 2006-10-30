require "monitor.rb"
require "fileutils.rb"

class TestMonitor < Test::Unit::TestCase
  def setup
    # Put some test files in the directory test_data
    FileUtils.rm_rf 'test_data'
    FileUtils.mkdir 'test_data'
    FileUtils.touch 'test_data/file1'
    
    @monitor = Monitor.new("test_data")
  end
  
  def teardown
    # Tidy up
    FileUtils.rm_rf 'test_data'
  end

  def test_empty    
    assert(!@monitor.exist?('file1'))
    assert(!@monitor.exist?('file2'))
  end
  
  def test_update
     # It should only update its knowledge of the files on calling update
    @monitor.update
    assert(@monitor.exist?('file1'))
    assert(!@monitor.exist?('file2'))    
  end
end
