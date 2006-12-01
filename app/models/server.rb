require 'socket'

class Server < ActiveRecord::Base
  belongs_to :directory

  def Server.this_server
    Server.find_or_create_by_name(this_hostname)
  end
  
  def Server.this_hostname
    Socket.gethostname
  end
  
  # Delete all directories on this server
  def delete_all_directories
    directory.full_set.each {|d| d.destroy}
  end
end
