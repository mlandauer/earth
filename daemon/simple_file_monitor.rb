class SimpleFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    @directory = File.expand_path(directory)
    @snapshot = SnapshotRecursive.new
    dir = directory_added(@directory)
    @directories = {@directory => dir}
  end
  
  def update   
    new_snapshot = SnapshotRecursive.new(@directory)
    Difference.changed_files_recursive(@snapshot, new_snapshot).each do |x|
      file_changed(@directories[File.dirname(x)], File.basename(x), new_snapshot.stat(x))
    end

    Difference.added_directories_recursive(@snapshot, new_snapshot).each do |x|
      dir = directory_added(x)
      @directories[x] = dir;
    end
    Difference.added_files_recursive(@snapshot, new_snapshot).each do |x|
      file_added(@directories[File.dirname(x)], File.basename(x), new_snapshot.stat(x))
    end
    Difference.removed_files_recursive(@snapshot, new_snapshot).each do |x|
      file_removed(@directories[File.dirname(x)], File.basename(x))
    end
    Difference.removed_directories_recursive(@snapshot, new_snapshot).each do |x|
      directory_removed(x)
      @directories.delete(x)
    end
    @snapshot = new_snapshot
  end
end
