require 'socket'

class Server < ActiveRecord::Base
  has_many :directories, :class_name => "Earth::Directory", :dependent => :destroy

  def Server.this_server
    Server.find_or_create_by_name(this_hostname)
  end
  
  def Server.this_hostname
    Socket.gethostname
  end
end
