require 'socket'

class FileDatabaseUpdater
  def initialize(server)
    # Clear out database
    FileInfo.delete_all
    DirectoryInfo.delete_all
    @server = server
  end
  
  def file_added(directory, name, stat)
    #puts "File ADDED: #{name} in directory #{directory.path}"
    FileInfo.create(:directory_info => directory, :name => name, :stat => stat)
  end
  
  def file_removed(directory, name)
    #puts "File REMOVED: #{name} in directory #{directory.path}"
    FileInfo.find_by_directory_info_and_name(directory, name).destroy
  end
  
  def file_changed(directory, name, stat)
    #puts "File CHANGED: #{name} in directory #{directory.path}"
    file = FileInfo.find_by_directory_info_and_name(directory, name)
    file.stat = stat
    file.save
  end
  
  def directory_added(path)
    #puts "Directory ADDED: #{path}"
    DirectoryInfo.create(:server => @server, :path => path)
  end
  
  def directory_removed(directory)
    #puts "Directory REMOVED: #{directory.path}"
    directory.destroy
  end
  
  def directory_changed(directory, stat)
    directory.stat = stat
    directory.save
  end
end
