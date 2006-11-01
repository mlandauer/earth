require 'fileutils'
require 'snapshot'

class TestSnapshot < Test::Unit::TestCase
  def setup
    # Put some test files in the directory test_data
    @dir = File.expand_path('test_data')
    @file1 = File.join(@dir, 'file1')
    @dir1 = File.join(@dir, 'dir1')
    @file2 = File.join(@dir1, 'file1')

    FileUtils.rm_rf @dir
    FileUtils.mkdir_p @dir1
    
    FileUtils.touch @file1
    FileUtils.touch @file2
  end
  
  def teardown
    # Tidy up
    FileUtils.rm_rf @dir
  end

  def test_changed_files
    # Changes the access and modification time on the file to be one minute in the past
    File.utime(Time.now - 60, Time.now - 60, @file2)
    s1 = Snapshot.new(@dir)
    FileUtils.touch @file2
    s2 = Snapshot.new(@dir)
    assert_equal([@file2], Snapshot.changed_files(s1, s2))
  end
end
