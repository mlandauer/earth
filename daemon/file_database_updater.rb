require 'socket'

class FileDatabaseUpdater
  def initialize
    # Clear out database
    FileInfo.delete_all
    DirectoryInfo.delete_all
  end
  
  def file_added(directory, name, stat)
    FileInfo.create(:directory_info => directory, :name => name,
      :modified => stat.mtime, :size => stat.size, :uid => stat.uid, :gid => stat.gid)
  end
  
  def file_removed(directory, name)
    FileInfo.delete_all(['directory_info_id = ? AND name = ?', directory.id, name])
  end
  
  def file_changed(directory, name, stat)
    file = FileInfo.find(:first, :conditions => ['directory_info_id = ? AND name = ?', directory.id, name])
    file.stat = stat
    file.save
  end
  
  def directory_added(path)
    DirectoryInfo.create(:server => Socket.gethostname, :path => path)
  end
  
  def directory_removed(directory)
    directory.destroy
  end
end
