# This contains some improvements to the better nested set plugin
require 'nested_set_improvements'

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
  class Directory < ActiveRecord::Base
    acts_as_nested_set
    has_many :files, :class_name => "Earth::File", :dependent => :delete_all
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
    
    # Size of the files contained directly in this directory
    def size
      a = Earth::File.sum(:size, :conditions => ['directory_id = ?', id])
      # For some reason the above will return nil when there aren't any files
      return a ? a : 0
    end
    
    def recursive_size
      Directory.sum(:size, :conditions => "lft >= #{lft} AND rgt <= #{rgt}",
        :joins => "LEFT JOIN files ON files.directory_id = directories.id").to_i
    end
    
    # Return all the root directories for the given server as an array
    # TODO: Currently not tested
    def Directory.roots_for_server(server)
      Directory.roots.find_all{|d| d.server_id == server.id}
    end
    
    # Set the path and server_id attributes based on name and parent_id
    def before_save
      if parent_id
        write_attribute(:path, ::File.join(parent.path, name))
        write_attribute(:server_id, parent.server_id)
      else
        write_attribute(:path, name)
      end
    end
    
    def path=(path)
      raise "Can't set path directly. Set name instead."
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

