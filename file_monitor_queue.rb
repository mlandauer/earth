FileAdded = Struct.new(:path, :name, :stat)
FileRemoved = Struct.new(:path, :name)
FileChanged = Struct.new(:path, :name, :stat)

class FileMonitorQueue < Queue
  include FileMonitorObserver
  
  def file_added(path, name, stat)
    push(FileAdded.new(path, name, stat))
  end
  
  def file_removed(path, name)
    push(FileRemoved.new(path, name))
  end
  
  def file_changed(path, name, stat)
    push(FileChanged.new(path, name, stat))
  end
end
