
class FileMonitorQueue < Queue
  DirectoryRemoved = Struct.new(:path)
  DirectoryAdded = Struct.new(:path)
  FileAdded = Struct.new(:path, :name, :stat)
  FileChanged = Struct.new(:path, :name, :stat)
  FileRemoved = Struct.new(:path, :name)

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
  
  def directory_removed(directory)
    push(DirectoryRemoved.new(directory.path))
  end
end
