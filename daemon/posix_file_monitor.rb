class PosixFileMonitor
  def initialize(directory)
    @server = directory.server
    snapshot = Snapshot.new(directory, self)
    @snapshots = DirectoryTree.new(directory.path, snapshot)
    # Retrieve all subdirectories from the database
    directory.all_children.each do |subdir|
      snapshot = Snapshot.new(subdir, self)
      @snapshots.add(subdir.path, snapshot)
    end
  end
  
  def directory_added(directory)
    snapshot = Snapshot.new(directory, self)
    @snapshots.add(directory.path, snapshot)
    snapshot.update
    directory
  end

  def directory_removed(directory)
    @snapshots.delete(directory.path)
  end
  
  def update
    @snapshots.clone.each {|snapshot| snapshot.update}
  end
end
