class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    directory = File.expand_path(directory)

    @snapshots = DirectoryTree.new(directory,
      Snapshot.new(@observer.directory_added(nil, directory), self))
  end
  
  # Diverting messages from Snapshot objects
  def directory_added(directory, name)
    if directory.nil?
      full_path = name
    else
      full_path = File.join(directory.path, name)
    end
    directory = @observer.directory_added(directory, name)

    snapshot = Snapshot.new(directory, self)
    @snapshots.add(full_path, snapshot)
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
