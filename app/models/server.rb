require 'socket'

class Server < ActiveRecord::Base
  def Server.find_this_server
    Server.find_by_name(Socket.gethostname)
  end
end
