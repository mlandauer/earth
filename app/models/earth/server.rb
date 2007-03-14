require 'socket'

module Earth

  class Server < ActiveRecord::Base
    has_many :directories, :dependent => :delete_cascade, :order => :lft

    @@config = nil    
    def self.config
      @@config = ApplicationController::webapp_config unless @@config
      @@config
    end
    
    def self.heartbeat_grace_period
      self.config["heartbeat_grace_period"].to_i
    end

    def Server.this_server
      Server.find_or_create_by_name(ENV["EARTH_HOSTNAME"] || this_hostname)
    end
    
    def Server.this_hostname
      Socket.gethostbyname(Socket.gethostname)[0]
    end
    
    def size
      size_sum = Size.new(0, 0, 0)
      Earth::Directory.roots_for_server(self).each do |d|
        size_sum += d.size
      end
      size_sum
    end

    def has_files?
      size.count > 0
    end
    
    def heartbeat
      self.heartbeat_time = Time.now.utc
      save!
    end
    
    def daemon_alive?
      if heartbeat_time.nil? or daemon_version.nil?
        false
      else
        (heartbeat_time + heartbeat_interval + Earth::Server.heartbeat_grace_period) >= Time::now
      end
    end

    def cache_complete?
      roots = Earth::Directory.roots_for_server(self) 
      (not roots.empty?) and roots.all? { |d| d.cache_complete? and not d.children.empty? }
    end
  end
end
