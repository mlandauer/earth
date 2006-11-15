require 'socket'

class FileDatabaseUpdater
  def initialize(server)
    # Clear out database
    FileInfo.delete_all
    DirectoryInfo.delete_all
    @server = server
  end
  
  def file_added(directory, name, stat)
    FileInfo.create(:directory_info => directory, :name => name, :stat => stat)
  end
  
  def file_removed(directory, name)
    FileInfo.find_by_directory_info_and_name(directory, name).destroy
  end
  
  def file_changed(directory, name, stat)
    file = FileInfo.find_by_directory_info_and_name(directory, name)
    file.stat = stat
    file.save
  end
  
  def directory_added(path)
    DirectoryInfo.create(:server => @server, :path => path)
  end
  
  def directory_removed(directory)
    directory.destroy
  end
end
