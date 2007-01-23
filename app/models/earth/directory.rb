
class File
  class Stat
    alias old_equals ==
    
    def ==(stat)
      if stat.class == self.class
        return old_equals(stat)
      else
        return stat == self
      end
    end
  end
end

module Earth
  #
  # This is used as the :extend option for the has_many :files
  # association below and allows setting the files explicitly if
  # they've been retrieved circumventing the association
  #
  module FilesExtension #:nodoc:
    def set(files)
      @target = files
      @loaded = true
    end
  end

  class Directory < ActiveRecord::Base
    acts_as_nested_set :scope => :server, :level_column => "level"
    has_many :files, :class_name => "Earth::File", :dependent => :delete_all, :order => :name, :extend => Earth::FilesExtension
    belongs_to :server
  
    Stat = Struct.new(:mtime)
    class Stat
      def ==(stat)
        mtime == stat.mtime
      end
    end
  
    # Convenience method for setting all the fields associated with stat in one hit
    def stat=(stat)
      self.modified = stat.mtime unless stat.nil?
    end
    
    # Returns a "fake" Stat object with some of the same information as File::Stat
    def stat
      Stat.new(modified) unless modified.nil?
    end
    
    # Returns the size of all the files (matching the search criterion) recursively
    # below this directory
    # This only requires the id of the current directory and so doesn't need to
    # protected in a transaction which simplified its use
    def size
      @cached_size || Earth::File.sum(:size, :conditions => "directories.lft >= #{self.lft} AND directories.lft <= #{self.rgt} AND directories.server_id = #{self.server_id}",
                                      :joins => "JOIN directories ON files.directory_id = directories.id").to_i
    end
    
    #
    # Set the recursive size 
    #
    def cached_size= (cached_size)
      @cached_size = cached_size
    end
    
    def recursive_file_count
      Earth::File.count(:conditions => "directories.lft >= #{self.lft} AND directories.lft <= #{self.rgt} AND directories.server_id = #{self.server_id}",
        :joins => "JOIN directories ON files.directory_id = directories.id").to_i
    end

    def size_and_count
      result = Earth::File.find(:first, 
                                :select => "SUM(files.size) AS sum, COUNT(*) AS count",
                                :joins => "JOIN directories ON files.directory_id = directories.id",
                                :conditions => ("directories.lft >= #{self.lft} " \
                                                + " AND directories.lft <= #{self.rgt} " \
                                                + " AND directories.server_id = #{self.server_id}"))
      [ (result["sum"] || 0).to_i, result["count"].to_i ]
    end
    
    def has_files?
      recursive_file_count > 0
    end
    
    # Return all the root directories for the given server as an array
    # TODO: Currently not tested
    def Directory.roots_for_server(server)
      Directory.roots.find_all{|d| d.server_id == server.id}
    end
    
    # Hmmm. How can I explain this? It's a really ugly hack. If parent_id isn't set and the normal
    # way of finding the path won't work you can explicitly set it for this object. Only used by the daemon.
    def path=(path)
      @cached_path = path
    end
    
    def path
      # Note: need to reverse ancestors with behavior compatible to nested_set
      # (as opposed to better_nested_set)
      @cached_path = self_and_ancestors.reverse.map{|x| x.name}.join('/') unless @cached_path
      @cached_path
    end

    def path_relative_to(some_parent)
      if some_parent.id.nil? or path.nil?
        path
      else
        result = path[some_parent.path.size+1..-1]
        if not result.nil? and result.size > 0
          "/" + result
        else
          ""
        end
      end
    end

    def set_parent_path(parent_path)
      if parent_path == ""
        @cached_path = name
      else
        @cached_path = "#{parent_path}/#{name}"
      end
    end
    
    # This assumes there are no overlapping directory trees
    def Directory.find_by_path(path)
      current = roots.find {|d| path[0, d.name.length] == d.name}
      if current.nil? || path.length == current.name.length
        return current
      end
      remaining = path[current.name.length+1 .. -1].split("/")
      
      while !remaining.empty? && !current.nil? do
        current = current.find_by_child_name(remaining.shift)
      end


      return current
    end
    
    # Returns the child of this directory with the given name
    def find_by_child_name(n)
      Directory.find(:first, :conditions => ['parent_id = ? AND name = ?', id, n])
    end
    
    # Iterate over each node of the tree. Move from the leaf nodes
    # back to the root
    def each 
      children.each do |child_node| 
        child_node.each { |e| yield e } 
      end 
      yield self 
    end
    
  end
end

