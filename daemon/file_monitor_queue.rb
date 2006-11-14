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
    directory = DirectoryInfo.new(path)
    push(DirectoryAdded.new(directory))
    directory
  end
  
  def directory_removed(directory)
    push(DirectoryRemoved.new(directory.path))
  end
end
