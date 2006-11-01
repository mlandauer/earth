require 'file_monitor.rb'
require 'file_info'

class MonitorWithDatabase < FileMonitor
  def initialize(directory)
    super(directory)
    # Clear out database
    FileInfo.delete_all
  end
  
  def file_added(full_path)
    FileInfo.create(:path => File.dirname(full_path), :name => File.basename(full_path))
  end
  
  def file_removed(full_path)
    FileInfo.delete_all(['path = ? AND name = ?', File.dirname(full_path), File.basename(full_path)])
  end
end
