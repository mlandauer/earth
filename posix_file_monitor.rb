class SnapshotNonRecursive
  def initialize(directory)
    @directory = File.expand_path(directory)
  end
end

class PosixFileMonitor < FileMonitorBase
  def initialize(directory)
    @snapshot = SnapshotNonRecursive.new(directory)
  end
  
  def update
    # Get the stat information of all the directories from the current snapshot
    # and find the directories which have different stat info now

    file_added(File.expand_path('test_data/file1'), File.lstat(File.expand_path('test_data/file1')))
    file_added(File.expand_path('test_data/dir1/file1'), File.lstat(File.expand_path('test_data/dir1/file1')))
  end
end
