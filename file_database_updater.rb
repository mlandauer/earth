require 'file_monitor.rb'
require 'file_info'

class FileDatabaseUpdater
  def initialize
    # Clear out database
    FileInfo.delete_all
  end
  
  def file_added(path, name, stat)
    FileInfo.create(:path => path, :name => name, :modified => stat.mtime, :size => stat.size)
  end
  
  def file_removed(path, name)
    FileInfo.delete_all(['path = ? AND name = ?', path, name])
  end
  
  def file_changed(path, name, stat)
    file = FileInfo.find(:first, :conditions => ['path = ? AND name = ?', path, name])
    file.modified = stat.mtime
    file.size = stat.size
    file.save
  end
end
