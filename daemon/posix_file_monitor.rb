class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)

    snapshot = Snapshot.new(directory, self)
    @snapshots = DirectoryTree.new(directory.path, snapshot)
    # Retrieve all subdirectories from the database
    directory.all_children.each do |subdir|
      snapshot = Snapshot.new(subdir, self)
      @snapshots.add(subdir.path, snapshot)
    end
  end
  
  # Diverting messages from Snapshot objects
  def directory_added(parent_directory, name)
    directory = @observer.directory_added(parent_directory, name)
    snapshot = Snapshot.new(directory, self)
    @snapshots.add(directory.path, snapshot)
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
