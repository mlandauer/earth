require 'socket'

class Server < ActiveRecord::Base
  belongs_to :directory_info

  def Server.this_server
    Server.find_or_create_by_name(this_hostname)
  end
  
  def Server.this_hostname
    Socket.gethostname
  end
end
