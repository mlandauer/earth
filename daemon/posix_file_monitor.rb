class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    directory = File.expand_path(directory)

    @snapshots = DirectoryTree.new(directory,
      Snapshot.new(self, @observer.directory_added(directory, nil)))
  end
  
  # Diverting messages from Snapshot objects
  def directory_added(path, stat)
    directory = @observer.directory_added(path, stat)

    snapshot = Snapshot.new(self, directory)
    @snapshots.add(path, snapshot)
    snapshot.update
    directory
  end

  # Diverting messages from Snapshot objects
  def directory_removed(directory)
    @snapshots.delete(directory.path)
    @observer.directory_removed(directory)
  end
  
  def update
    @snapshots.clone.each {|snapshot| snapshot.update}
  end
end
