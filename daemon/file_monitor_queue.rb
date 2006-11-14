class FileMonitorQueue < Queue
  DirectoryInfo = Struct.new(:path)

  def file_added(directory, name, stat)
    push(FileAdded.new(directory.path, name, stat))
  end
  
  def file_removed(directory, name)
    push(FileRemoved.new(directory.path, name))
  end
  
  def file_changed(directory, name, stat)
    push(FileChanged.new(directory.path, name, stat))
  end
  
  def directory_added(path)
    push(DirectoryAdded.new(path))
    DirectoryInfo.new(path)
  end
  
  def directory_removed(path)
    push(DirectoryRemoved.new(path))
  end
end
