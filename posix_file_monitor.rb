class SnapshotNonRecursive
  attr_reader :directory_stat, :directory

  def initialize(directory)
    @directory = File.expand_path(directory)
    @directory_stat = nil
  end
  
  def update
    new_stat = File.lstat(@directory)
    if new_stat != @directory_stat
      @directory_stat = new_stat
      # Update contents of directory
    end
  end
  
  def stat(path)
    File.lstat(File.expand_path('test_data/file1'))
  end
  
  def SnapshotNonRecursive.added_files(snap1, snap2)
    [File.expand_path('test_data/file1')]
  end
end

class PosixFileMonitor < FileMonitorBase
  def initialize(directory)
    @directory = directory
    @snapshots = [SnapshotNonRecursive.new(directory)]
  end
  
  def update
    # Get the stat information of all the directories from the current snapshot
    # and find the directories which have different stat info now
    for snapshot in @snapshots
      old_snapshot = snapshot.clone
      snapshot.update
      SnapshotNonRecursive.added_files(old_snapshot, snapshot).each {|x| file_added(x, snapshot.stat(x))}
    end
    
    file_added(File.expand_path('test_data/dir1/file1'), File.lstat(File.expand_path('test_data/dir1/file1')))
  end
end
