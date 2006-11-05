class PosixFileMonitor < FileMonitorBase
  def initialize(directory)
    @directory = directory
    @snapshots = Hash.new
    @snapshots[directory] = SnapshotNonRecursive.new
  end
  
  def remove_directory(directory)
    #puts "Removing directory #{directory}"
    # First remove subdirectories
    @snapshots[directory].subdirectory_names.each {|x| remove_directory(x)}
    @snapshots[directory].file_names.each {|x| file_removed(x)}
    @snapshots.delete(directory)
  end
  
  def add_directory(directory)
    snapshot = SnapshotNonRecursive.new
    @snapshots[directory] = snapshot
    old_snapshot = snapshot.deep_copy
    snapshot.update(directory)

    Difference.added_files(old_snapshot, snapshot).each {|x| file_added(x, snapshot.stat(x))}
    Difference.added_directories(old_snapshot, snapshot).each {|x| add_directory(x)}
  end
  
  def update
    added_directories = []
    removed_directories = []
    
    @snapshots.each do |directory, snapshot|
      old_snapshot = snapshot.deep_copy
      snapshot.update(directory)

      added_directories += Difference.added_directories(old_snapshot, snapshot)
      removed_directories += Difference.removed_directories(old_snapshot, snapshot)
      
      Difference.added_files(old_snapshot, snapshot).each {|x| file_added(x, snapshot.stat(x))}
      Difference.removed_files(old_snapshot, snapshot).each {|x| file_removed(x)}
      Difference.changed_files(old_snapshot, snapshot).each {|x| file_changed(x, snapshot.stat(x))}
    end
    
    # Doing this outside the loop above so that we are not adding and removing from @snapshots
    # while we're in the middle of the loop
    added_directories.each {|x| add_directory(x)}
    removed_directories.each {|x| remove_directory(x)}
  end
end
