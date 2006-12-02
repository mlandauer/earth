require 'socket'

class Server < ActiveRecord::Base
  belongs_to :directory

  def Server.this_server
    Server.find_or_create_by_name(this_hostname)
  end
  
  def Server.this_hostname
    Socket.gethostname
  end

  # When destroying this server destroy all associated directories and files
  def after_destroy
    directory.full_set.each do |d|
      FileInfo.delete_all ['directory_id = ?', d.id]
    end
    directory.destroy
  end  
end
