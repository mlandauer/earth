# For FileAdded struct
#require 'changes'

class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    @snapshots = {File.expand_path(directory) => Snapshot.new}
    directory_added(File.expand_path(directory))
  end
  
  def remove_directory(directory)
    @snapshots[directory].subdirectory_names.each {|x| remove_directory(File.join(directory, x))}
    @snapshots[directory].file_names.each {|x| file_removed(File.join(directory, x))}
    @snapshots.delete(directory)
    directory_removed(directory)
  end
  
  def add_directory(directory)
    directory_added(directory)
    snapshot = Snapshot.new
    @snapshots[directory] = snapshot
    old_snapshot = snapshot.deep_copy
    snapshot.update(directory)

    Difference.added_files(old_snapshot, snapshot).each {|x| file_added(directory, x, snapshot.stat(x))}
    Difference.added_directories(old_snapshot, snapshot).each {|x| add_directory(File.join(directory, x))}
  end
  
  def update
    added_directories = []
    removed_directories = []
    added_files = []
    
    @snapshots.each do |directory, snapshot|
      old_snapshot = snapshot.deep_copy
      snapshot.update(directory)

      added_directories += Difference.added_directories(old_snapshot, snapshot).map{|d| File.join(directory, d)}
      removed_directories += Difference.removed_directories(old_snapshot, snapshot).map{|d| File.join(directory, d)}
      added_files += Difference.added_files(old_snapshot, snapshot).map {|x| FileAdded.new(directory, x, snapshot.stat(x))}
      
      Difference.removed_files(old_snapshot, snapshot).each {|x| file_removed(directory, x)}
      Difference.changed_files(old_snapshot, snapshot).each {|x| file_changed(directory, x, snapshot.stat(x))}
    end
    
    # Doing this outside the loop above so that we are not adding and removing from @snapshots
    # while we're in the middle of the loop
    # TODO: Take account of possible duplicates in added_directories and removed_directories
    # TODO: file_added and directory_added messages do appear currently in a strange order
    added_directories.each {|x| add_directory(x)}
    added_files.each {|x| file_added(x.path, x.name, x.stat)}
    removed_directories.each {|x| remove_directory(x)}
  end
end
