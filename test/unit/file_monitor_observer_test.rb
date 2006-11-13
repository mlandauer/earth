# Tests that apply to all classes that monitor derived
# classes of FileMonitor
# Making this a module that we mix-in so that the test runner
# doesn't try to run this abstract test
module FileMonitorObserverTest
  # Duck typing comes in handy here. Making fake File::Stat object
  Stat = Struct.new(:mtime, :size, :uid, :gid)

  def setup
    @dir = File.expand_path('test_data')
    @dir1 = File.join(@dir, 'dir1')
    @updater = updater
    # 1st of January 2000
    @stat1 = Stat.new(Time.local(2000, 1, 1), 24, 100, 200)
    @stat2 = Stat.new(Time.local(2001, 1, 1), 53, 100, 200)
  end
  
  # When we call add_directory it should return a directory object
  def test_add_directory_returned_value
    d = @updater.directory_added(@dir)
    assert_equal(@dir, d.path)
  end
end

