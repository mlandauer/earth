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
    
    @snapshot = SnapshotRecursive.new(@dir)
  end
  
  def teardown
    # Tidy up
    FileUtils.rm_rf @dir
  end
  
  def test_empty
    assert(!SnapshotRecursive.new.exist?(File.join(@dir, 'file1')))
    assert(!SnapshotRecursive.new.exist?(File.join(@dir, 'file2')))
  end
  
  def test_simple
    assert(@snapshot.exist?(File.join(@dir, 'file1')))
    assert(@snapshot.exist?(File.join(@dir, 'dir1/file1')))
    # Check files that don't exist
    assert(!@snapshot.exist?(File.join(@dir, 'file2')))    
    assert(!@snapshot.exist?(File.join(@dir, 'dir1/file2')))
  end
  
  # Those pesky '.' and '..' directories shouldn't be there
  def test_hidden_files
    assert(!@snapshot.exist?(File.join(@dir, '.')))
    assert(!@snapshot.exist?(File.join(@dir, '..'))) 
  end
  
  def test_changed_files
    # Changes the access and modification time on the file to be one minute in the past
    File.utime(Time.now - 60, Time.now - 60, @file2)
    s1 = SnapshotRecursive.new(@dir)
    FileUtils.touch @file2
    s2 = SnapshotRecursive.new(@dir)
    assert_equal([@file2], Difference.changed_files_recursive(s1, s2))
  end
end
