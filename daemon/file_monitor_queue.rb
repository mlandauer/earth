class FileMonitorQueue < Queue
  DirectoryRemoved = Struct.new(:path)
  DirectoryChanged = Struct.new(:path, :stat)
  DirectoryAdded = Struct.new(:path)
  FileAdded = Struct.new(:path, :name, :stat)
  FileChanged = Struct.new(:path, :name, :stat)
  FileRemoved = Struct.new(:path, :name)

  def file_added(directory, name, stat)
    push(FileAdded.new(directory.path, name, stat))
    FileInfo.new(:directory_info => directory, :name => name, :stat => stat)
  end
  
  def file_removed(file)
    push(FileRemoved.new(file.path, file.name))
  end
  
  def file_changed(file, stat)
    push(FileChanged.new(file.path, file.name, stat))
  end
  
  def directory_added(directory, name)
    if directory.nil?
      full_path = name
    else
      full_path = File.join(directory.path, name)
    end
    push(DirectoryAdded.new(full_path))
    DirectoryInfo.new(:path => full_path, :modified => nil)
  end
  
  def directory_removed(directory)
    push(DirectoryRemoved.new(directory.path))
  end
  
  def directory_changed(directory, stat)
    push(DirectoryChanged.new(directory.path, stat))
    directory.stat = stat
  end
end
