class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)

    snapshot = Snapshot.new(directory, self)
    @snapshots = DirectoryTree.new(directory.path, snapshot)
    add_children_to_snapshots(directory)
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
  
private

  def add_children_to_snapshots(directory)
    directory.children.each do |x|
      snapshot = Snapshot.new(x, self)
      @snapshots.add(x.path, snapshot)
      add_children_to_snapshots(x)
    end
  end
end
