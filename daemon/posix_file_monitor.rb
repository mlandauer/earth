class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    directory = File.expand_path(directory)

    @snapshots = {directory => Snapshot.new(self, @observer.directory_added(directory))}
    # Keeps track of added an removed directories in each update cycle
    @added_snapshots = Hash.new
    @removed_paths = []
  end
  
  # Diverting messages from Snapshot objects
  def directory_added(path)
    directory = @observer.directory_added(path)

    snapshot = Snapshot.new(self, directory)
    snapshot.update
    @added_snapshots[path] = snapshot
    directory
  end

  # Diverting messages from Snapshot objects
  def directory_removed(directory)
    snapshot = @snapshots[directory.path]

    snapshot.subdirectories.each_value {|directory| directory_removed(directory)}
    snapshot.file_names.each {|x| file_removed(directory, x)}
    @removed_paths << directory.path

    @observer.directory_removed(directory)
  end
  
  def update
    @snapshots.each_value {|snapshot| snapshot.update}
    # Do the adding and remove of snapshots outside of the loop above
    # as otherwise this can cause:
    # RuntimeError: hash modified during iteration.
    # TODO: Understand "hash modified during iteration" properly
    @snapshots.merge!(@added_snapshots)
    @added_snapshots.clear
    @removed_paths.each {|p| @snapshots.delete(p)}
    @removed_paths.clear
  end
end
