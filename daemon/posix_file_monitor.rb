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
    snapshot = @snapshots[directory.path]

    snapshot.subdirectories.each_value {|directory| directory_removed(directory)}
    snapshot.file_names.each {|x| file_removed(directory, x)}
    @snapshots.delete(directory.path)

    @observer.directory_removed(directory)
  end
  
  def update
    @snapshots.each_value {|snapshot| snapshot.update} 
  end
end
