require "monitor"

class MonitorWithDatabase < Monitor
  def initialize(directory)
    super(directory)
    # Clear out database
    Files.delete_all
  end
  
  def file_added(name)
    Files.create(:path => name)
  end
  
  def file_removed(name)
    Files.delete_all('path = #{name}')
  end
end
