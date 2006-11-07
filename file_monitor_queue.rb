class FileMonitorQueue < Queue
  def file_added(path, name, stat)
    push(FileAdded.new(path, name, stat))
  end
  
  def file_removed(path, name)
    push(FileRemoved.new(path, name))
  end
  
  def file_changed(path, name, stat)
    push(FileChanged.new(path, name, stat))
  end
  
  def directory_added(path)
    push(DirectoryAdded.new(path))
  end
  
  def directory_removed(path)
    push(DirectoryRemoved.new(path))
  end
end
