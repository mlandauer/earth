require 'socket'

class FileDatabaseUpdater
  def initialize(server)
    @server = server
  end
  
  def directory_added(directory)
  end
  
  def directory_removed(directory)
  end
end
