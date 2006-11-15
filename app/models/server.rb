require 'socket'

class Server < ActiveRecord::Base
  def Server.this_server
    server = Server.find_by_name(this_hostname)
    server ? server : raise("This server is not registered in the database. Use the web admin front-end to add it")
  end
  
  def Server.this_hostname
    Socket.gethostname
  end
end
