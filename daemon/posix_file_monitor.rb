class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    directory = File.expand_path(directory)

    @snapshots = {directory => Snapshot.new(self, @observer.directory_added(directory))}
  end
  
  # Diverting messages from Snapshot objects
  def directory_removed(directory)
    remove_directory(directory.path)
    @observer.directory_removed(directory)
  end
  
  def remove_directory(path)
    directory = @snapshots[path].directory

    @snapshots[path].subdirectory_names.each do |x|
      directory_removed(@snapshots[File.join(path, x)].directory)
    end
    @snapshots[path].file_names.each {|x| file_removed(directory, x)}
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
      Difference.removed_directories(old_snapshot, snapshot).each do |d|
        directory_removed(@snapshots[File.join(path, d)].directory)
      end
    end
  end
end
