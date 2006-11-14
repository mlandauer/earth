class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    @snapshots = {File.expand_path(directory) => Snapshot.new}
    dir = directory_added(File.expand_path(directory))
    @directories = {File.expand_path(directory) => dir}
  end
  
  def remove_directory(directory)
    @snapshots[directory].subdirectory_names.each {|x| remove_directory(File.join(directory, x))}
    # TODO: Check the line below
    @snapshots[directory].file_names.each {|x| file_removed(File.join(directory, x))}
    @snapshots.delete(directory)
    directory_removed(@directories[directory])
    @directories.delete(directory)
  end
  
  def add_directory(directory)
    dir = directory_added(directory)
    snapshot = Snapshot.new
    @snapshots[directory] = snapshot
    @directories[directory] = dir
    old_snapshot = snapshot.deep_copy
    snapshot.update(directory)

    Difference.added_files(old_snapshot, snapshot).each {|x| file_added(dir, x, snapshot.stat(x))}
    Difference.added_directories(old_snapshot, snapshot).each {|x| add_directory(File.join(directory, x))}
  end
  
  def update
    added_directories = []
    removed_directories = []
    added_files = []
    
    @snapshots.each do |path, snapshot|
      directory = @directories[path]
      old_snapshot = snapshot.deep_copy
      snapshot.update(path)

      added_directories += Difference.added_directories(old_snapshot, snapshot).map{|d| File.join(path, d)}
      removed_directories += Difference.removed_directories(old_snapshot, snapshot).map{|d| File.join(path, d)}
      added_files += Difference.added_files(old_snapshot, snapshot).map {|x| FileAdded.new(path, x, snapshot.stat(x))}
      
      Difference.removed_files(old_snapshot, snapshot).each {|x| file_removed(directory, x)}
      Difference.changed_files(old_snapshot, snapshot).each {|x| file_changed(directory, x, snapshot.stat(x))}
    end
    
    # Doing this outside the loop above so that we are not adding and removing from @snapshots
    # while we're in the middle of the loop
    # TODO: Take account of possible duplicates in added_directories and removed_directories
    # TODO: file_added and directory_added messages do appear currently in a strange order
    added_directories.each {|x| add_directory(x)}
    added_files.each {|x| file_added(@directories[x.path], x.name, x.stat)}
    removed_directories.each {|x| remove_directory(x)}
  end
end
