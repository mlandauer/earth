require 'socket'

module Earth
  class Server < ActiveRecord::Base
    has_many :directories, :dependent => :destroy, :order => :lft
  
    def Server.this_server
      Server.find_or_create_by_name(this_hostname)
    end
    
    def Server.this_hostname
      Socket.gethostname
    end
    
    def size(filename_filter = '*')
      if @cached_size.nil? || @cached_filename_filter != filename_filter
        @cached_size = size_uncached(filename_filter)
        @cached_filename_filter = filename_filter
      end
      @cached_size
    end
    
    def size_uncached(filename_filter = '*')
      roots = Earth::Directory.roots_for_server(self)
      Earth::Directory.with_scope(:find => {:conditions => ["files.name LIKE ?", filename_filter.tr('*', '%')]}) do
        roots.map{|d| d.size}.sum
      end
    end
    
    def recursive_file_count(filename_filter = '*')
      roots = Earth::Directory.roots_for_server(self)
      Earth::Directory.with_scope(:find => {:conditions => ["files.name LIKE ?", filename_filter.tr('*', '%')]}) do
        roots.map{|d| d.recursive_file_count}.sum
      end
    end
    
    def has_files?(filename_filter = '*')
      recursive_file_count(filename_filter) > 0
    end
  end
end
