class PosixFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    directory = File.expand_path(directory)

    @snapshots = {directory => Snapshot.new(self, @observer.directory_added(directory))}
  end
  
  # Diverting messages from Snapshot objects
  def directory_added(directory)
    dir = @observer.directory_added(directory)

    snapshot = Snapshot.new(self, dir)
    snapshot.update
    @snapshots[dir.path] = snapshot
    dir
  end

  # Diverting messages from Snapshot objects
  def directory_removed(directory)
    snapshot = @snapshots[directory.path]
    directory = snapshot.directory

    snapshot.subdirectory_names.each do |x|
      directory_removed(@snapshots[File.join(directory.path, x)].directory)
    end
    snapshot.file_names.each {|x| file_removed(directory, x)}
    @snapshots.delete(directory.path)

    @observer.directory_removed(directory)
  end
  
  def update
    @snapshots.each_value {|snapshot| snapshot.update} 
  end
end
