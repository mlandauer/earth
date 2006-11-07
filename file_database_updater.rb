require 'file_monitor.rb'
require 'file_info'
require 'socket'

class FileDatabaseUpdater
  def initialize
    # Clear out database
    FileInfo.delete_all
    DirectoryInfo.delete_all
  end
  
  def file_added(path, name, stat)
    FileInfo.create(:server => Socket.gethostname, :path => path, :name => name,
      :modified => stat.mtime, :size => stat.size, :uid => stat.uid, :gid => stat.gid)
  end
  
  def file_removed(path, name)
    FileInfo.delete_all(['path = ? AND name = ?', path, name])
  end
  
  def file_changed(path, name, stat)
    file = FileInfo.find(:first, :conditions => ['path = ? AND name = ?', path, name])
    file.modified = stat.mtime
    file.size = stat.size
    file.uid = stat.uid
    file.gid = stat.gid
    file.save
  end
  
  def directory_added(path)
    DirectoryInfo.create(:server => Socket.gethostname, :path => path)
  end
  
  def directory_removed(path)
    DirectoryInfo.delete_all(['server = ? AND path = ?', Socket.gethostname, path])
  end
end
