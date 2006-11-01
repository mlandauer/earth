require 'file_monitor.rb'
require 'file_info'

class MonitorWithDatabase < FileMonitor
  def initialize(directory)
    super(directory)
    # Clear out database
    FileInfo.delete_all
  end
  
  def file_added(path, name, stat)
    FileInfo.create(:path => path, :name => name, :modified => stat.mtime, :size => stat.size)
  end
  
  def file_removed(path, name)
    FileInfo.delete_all(['path = ? AND name = ?', path, name])
  end
end
