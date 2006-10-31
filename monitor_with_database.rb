require 'file_monitor.rb'
require 'file_info'

class MonitorWithDatabase < FileMonitor
  def initialize(directory)
    super(directory)
    # Clear out database
    FileInfo.delete_all
  end
  
  def file_added(name)
    FileInfo.create(:path => name)
  end
  
  def file_removed(name)
    FileInfo.delete_all(['path = ?', name])
  end
end
