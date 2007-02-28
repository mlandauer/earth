require 'socket'

module Earth

  class Server < ActiveRecord::Base
    has_many :directories, :dependent => :delete_cascade, :order => :lft
  
    cattr_accessor :config
    cattr_accessor :heartbeat_grace_period
    self.config = YAML.load(::File.open(::File.dirname(__FILE__) + "/../../../config/earth-webapp.yml"))
    self.heartbeat_grace_period = eval(self.config["heartbeat_grace_period"])

    def Server.this_server
      Server.find_or_create_by_name(ENV["EARTH_HOSTNAME"] || this_hostname)
    end
    
    def Server.this_hostname
      Socket.gethostbyname(Socket.gethostname)[0]
    end
    
    def bytes_blocks_and_count
      size_sum = Size.new(0, 0, 0)
      Earth::Directory.roots_for_server(self).each do |d|
        size_sum += d.size
      end
      [size_sum.bytes, size_sum.blocks, size_sum.count]
    end
    
    def bytes
      bytes, blocks, count = bytes_blocks_and_count
      bytes
    end
    
    def recursive_file_count
      bytes, blocks, count = bytes_blocks_and_count
      count
    end
    
    def has_files?
      recursive_file_count > 0
    end
    
    def heartbeat
      self.heartbeat_time = Time.now
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
