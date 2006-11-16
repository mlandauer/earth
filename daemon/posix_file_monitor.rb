class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    directory = File.expand_path(directory)

    @snapshots = {directory => Snapshot.new(self, @observer.directory_added(directory))}
  end
  
  # Diverting messages from Snapshot objects
  def directory_added(path)
    directory = @observer.directory_added(path)

    snapshot = Snapshot.new(self, directory)
    snapshot.update
    @snapshots[path] = snapshot
    directory
  end

  # Diverting messages from Snapshot objects
  def directory_removed(directory)
    @snapshots.delete(directory.path)    
    @observer.directory_removed(directory)
  end
  
  def update
    # Do the iteration on a cloned hash so that we are not adding and
    # removing snapshots from a hash we are iterating over. If we don't
    # do this we can get:
    # RuntimeError: hash modified during iteration.
    # TODO: We really need to iterate from the leaf nodes to the top so
    # that we never delete stuff up the tree before the stuff at the bottom
    @snapshots.clone.each_value {|snapshot| snapshot.update}
  end
end
