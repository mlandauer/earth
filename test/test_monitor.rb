require "monitor.rb"
require "fileutils.rb"

class TestMonitor < Test::Unit::TestCase
  def test_simple
    # Put some test files in the directory test_data
    FileUtils.rm_rf 'test_data'
    FileUtils.mkdir 'test_data'
    FileUtils.touch 'test_data/file1'
    
    monitor = Monitor.new("test_data")
    assert(monitor.exist?('test_data/file1'))
    assert(!monitor.exist?('test_data/file2'))

    # Tidy up
    FileUtils.rm_rf 'test_data'
  end
end
