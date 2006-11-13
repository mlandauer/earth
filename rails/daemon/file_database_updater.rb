require 'socket'

class FileDatabaseUpdater
  def initialize
    # Clear out database
    FileInfo.delete_all
    DirectoryInfo.delete_all
  end
  
  def file_added(path, name, stat)
    # TODO: Currently very inefficient because need to a find before any add
    directory = DirectoryInfo.find(:first, :conditions => ['server = ? AND path = ?', Socket.gethostname, path])
    raise "No directory found" if directory.nil?
    FileInfo.create(:directory_info => directory, :name => name,
      :modified => stat.mtime, :size => stat.size, :uid => stat.uid, :gid => stat.gid)
  end
  
  def file_removed(path, name)
    # TODO: Currently very inefficient because need to a find before any add
    directory = DirectoryInfo.find(:first, :conditions => ['server = ? AND path = ?', Socket.gethostname, path])
    raise "No directory found" if directory.nil?
    FileInfo.delete_all(['directory_info_id = ? AND name = ?', directory.id, name])
  end
  
  def file_changed(path, name, stat)
    # TODO: Doing this in a very stupid way to start with
    directory = DirectoryInfo.find(:first, :conditions => ['server = ? AND path = ?', Socket.gethostname, path])
    raise "No directory found" if directory.nil?
    file = FileInfo.find(:first, :conditions => ['directory_info_id = ? AND name = ?', directory.id, name])
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
