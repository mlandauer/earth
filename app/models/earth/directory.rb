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
    acts_as_nested_set :scope => :server
    has_many :files, :class_name => "Earth::File", :dependent => :delete_all, :order => :name
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
    
    # This only requires the id of the current directory and so doesn't need to
    # protected in a transaction which simplified its use
    def recursive_size
      Directory.sum(:size, :conditions => "directories.lft >= parent.lft AND directories.rgt <= parent.rgt",
        :joins => "LEFT JOIN directories AS parent ON parent.id = #{id} LEFT JOIN files ON files.directory_id = directories.id").to_i
    end
    
    # Return all the root directories for the given server as an array
    # TODO: Currently not tested
    def Directory.roots_for_server(server)
      Directory.roots.find_all{|d| d.server_id == server.id}
    end
    
    def path
      self_and_ancestors.map{|x| x.name}.join('/')
    end
    
    # This assumes there are no overlapping directory trees
    def Directory.find_by_path(path)
      current = roots.find {|d| path[0, d.name.length] == d.name}
      if path.length == current.name.length || current.nil?
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

