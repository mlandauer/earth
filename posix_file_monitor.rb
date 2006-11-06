class PosixFileMonitor < FileMonitor
  def initialize(directory)
    @snapshots = {directory => Snapshot.new}
  end
  
  def remove_directory(directory)
    @snapshots[directory].subdirectory_names.each {|x| remove_directory(File.join(directory, x))}
    @snapshots[directory].file_names.each {|x| file_removed(File.join(directory, x))}
    @snapshots.delete(directory)
  end
  
  def add_directory(directory)
    snapshot = Snapshot.new
    @snapshots[directory] = snapshot
    old_snapshot = snapshot.deep_copy
    snapshot.update(directory)

    Difference.added_files(old_snapshot, snapshot).each {|x| file_added(File.join(directory, x), snapshot.stat(x))}
    Difference.added_directories(old_snapshot, snapshot).each {|x| add_directory(File.join(directory, x))}
  end
  
  def update
    added_directories = []
    removed_directories = []
    
    @snapshots.each do |directory, snapshot|
      old_snapshot = snapshot.deep_copy
      snapshot.update(directory)

      added_directories += Difference.added_directories(old_snapshot, snapshot).map{|d| File.join(directory, d)}
      removed_directories += Difference.removed_directories(old_snapshot, snapshot).map{|d| File.join(directory, d)}
      
      Difference.added_files(old_snapshot, snapshot).each {|x| file_added(File.join(directory, x), snapshot.stat(x))}
      Difference.removed_files(old_snapshot, snapshot).each {|x| file_removed(File.join(directory, x))}
      Difference.changed_files(old_snapshot, snapshot).each {|x| file_changed(File.join(directory, x), snapshot.stat(x))}
    end
    
    # Doing this outside the loop above so that we are not adding and removing from @snapshots
    # while we're in the middle of the loop
    # TODO: Take account of possible duplicates in added_directories and removed_directories
    added_directories.each {|x| add_directory(x)}
    removed_directories.each {|x| remove_directory(x)}
  end
end
