require 'socket'

class FileDatabaseUpdater
  def initialize(server)
    @server = server
  end
  
  def file_added(directory, name, stat)
    #puts "File ADDED: #{name} in directory #{directory.path}"
    FileInfo.create(:directory => directory, :name => name, :stat => stat)
  end
  
  def file_removed(file)
    #puts "File REMOVED: #{file.name} in directory #{file.directory.path}"
    file.destroy
  end
  
  def file_changed(file, stat)
    #puts "File CHANGED: #{file.name} in directory #{file.path}"
    file.stat = stat
    file.save
  end
  
  def directory_added(parent_directory, name)
    directory = @server.directories.create(:name => name, :parent => parent_directory)
    #puts "Directory ADDED: #{directory.path}"
    directory
  end
  
  def directory_removed(directory)
    #puts "Directory REMOVED: #{directory.path}"
    directory.destroy
  end
  
  def directory_changed(directory, stat)
    #puts "Directory CHANGED: #{directory.path}"
    directory.reload
    directory.stat = stat
    directory.save
  end
end
