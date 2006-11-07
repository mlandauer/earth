class SimpleFileMonitor < FileMonitor
  def initialize(directory)
    @directory = directory
    @snapshot = SnapshotRecursive.new
  end
  
  def update   
    new_snapshot = SnapshotRecursive.new(@directory)
    Difference.added_directories_recursive(@snapshot, new_snapshot).each {|x| directory_added(x)}
    Difference.added_files_recursive(@snapshot, new_snapshot).each {|x| file_added(File.dirname(x), File.basename(x), new_snapshot.stat(x))}
    Difference.removed_files_recursive(@snapshot, new_snapshot).each {|x| file_removed(File.dirname(x), File.basename(x))}
    Difference.changed_files_recursive(@snapshot, new_snapshot).each {|x| file_changed(File.dirname(x), File.basename(x), new_snapshot.stat(x))}
    @snapshot = new_snapshot
  end
end
