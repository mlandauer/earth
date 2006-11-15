class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    directory = File.expand_path(directory)

    @snapshots = {directory => Snapshot.new(self, @observer.directory_added(directory))}
  end
  
  def remove_directory(path)
    directory = @snapshots[path].directory

    @snapshots[path].subdirectory_names.each {|x| remove_directory(File.join(path, x))}
    @snapshots[path].file_names.each {|x| file_removed(directory, x)}
    directory_removed(directory)
    @snapshots.delete(path)
  end
  
  # Diverting messages from Snapshot objects
  def directory_added(directory)
    dir = @observer.directory_added(directory)

    snapshot = Snapshot.new(self, dir)
    snapshot.update
    @snapshots[dir.path] = snapshot
  end

  def update
    @snapshots.each do |path, snapshot|
      directory = snapshot.directory
      old_snapshot = snapshot.deep_copy
      snapshot.update

      Difference.removed_files(old_snapshot, snapshot).each {|x| file_removed(directory, x)}
      Difference.removed_directories(old_snapshot, snapshot).each {|d| remove_directory(File.join(path, d))}
    end
  end
end
