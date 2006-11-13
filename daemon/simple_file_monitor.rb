class SimpleFileMonitor < FileMonitor
  def initialize(directory, observer)
    super(observer)
    @directory = File.expand_path(directory)
    @snapshot = SnapshotRecursive.new
    directory_added(@directory)
  end
  
  def update   
    new_snapshot = SnapshotRecursive.new(@directory)
    Difference.changed_files_recursive(@snapshot, new_snapshot).each {|x| file_changed(File.dirname(x), File.basename(x), new_snapshot.stat(x))}

    Difference.added_directories_recursive(@snapshot, new_snapshot).each {|x| directory_added(x)}
    Difference.added_files_recursive(@snapshot, new_snapshot).each {|x| file_added(File.dirname(x), File.basename(x), new_snapshot.stat(x))}
    Difference.removed_files_recursive(@snapshot, new_snapshot).each {|x| file_removed(File.dirname(x), File.basename(x))}
    Difference.removed_directories_recursive(@snapshot, new_snapshot).each {|x| directory_removed(x)}
    @snapshot = new_snapshot
  end
end
