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

module SymetrieCom
  module Acts
    module NestedSet
      module InstanceMethods
        
        # Overriding implementation from betternested set 
        def before_destroy
        end

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
    
    # Before destroying this object instantiate and then destroy all the children first
    # This ensures that callbacks are called such as those that destroy associated files
    def destroy_with_children
      children.each {|c| c.destroy_with_children}
      destroy_without_children
    end

    # This is a Rails 1.2'ism
    alias_method_chain :destroy, :children
    
    # Override the default implementation of update to write all attributes except
    # lft, rgt and parent_id
    def update_except_lft_rgt_parent
      a = attributes_with_quotes(false)
      a.delete(left_col_name)
      a.delete(right_col_name)
      a.delete(parent_col_name)
      connection.update(
        "UPDATE #{self.class.table_name} " +
        "SET #{quoted_comma_pair_list(connection, a)} " +
        "WHERE #{self.class.primary_key} = #{quote_value(id)}",
        "#{self.class.name} Update"
      )
    end
    
    alias :update_including_lft_rgt_parent :update
    alias :update :update_except_lft_rgt_parent
    
    def has_children?
      reload
      children_count > 0
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
    
    def parent=(parent)
      self.parent_id = parent.id unless parent.nil?
    end
    
    def parent_id=(id)
      write_attribute(:parent_id, id)
      @parent_id_updated = true
    end
    
    def after_save
      if @parent_id_updated
        move_to_child_of(parent)
        @parent_id_updated = false
      end
    end
    
    # Set the path attribute based on name and parent_id
    def before_save
      if parent_id
        write_attribute(:path, ::File.join(parent.path, name))
      else
        write_attribute(:path, name)
      end
    end
    
    def path=(path)
      raise "Can't set path directly. Set name instead."
    end
    
    alias :children_no_caching :children
    def children(reload = false)
      @children = children_no_caching if @children.nil? || reload
      return @children
    end
    
    def child_create(attributes)
      raise "Can't set parent or server_id" if attributes[:parent] || attributes[:server_id]
      directory = Directory.create(attributes.merge(:parent => self, :server_id => server_id))
      # Adding this directory to children at the front to maintain the same order as children(true)
      @children = [directory] + @children if @children
      directory
    end
    
    def child_delete(child)
      @children.delete(child) {raise "Not a child of this directory"} if @children
      child.destroy
    end
    
    # Iterate over each node of the tree. Move from the leaf nodes
    # back to the root
    def each 
      children.each do |child_node| 
        child_node.each { |e| yield e } 
      end 
      yield self 
    end
    
    # Only use this if you know what you're doing
    def set_cached_children(children)
      @children = children
    end
    
    # Load all the children and the children of children, etc. so that they
    # can be accesed via the "children" method without requiring any db queries
    def load_all_children
      child_by_id = {id => self}
      children_of = {}
      all_children.each do |child|
        child_by_id[child.id] = child
        if children_of[child.parent_id].nil?
          children_of[child.parent_id] = []
        end
        children_of[child.parent_id] << child
      end
      child_by_id.each do |id, child|
        child.set_cached_children([])
      end
      children_of.each do |id, children|
        child_by_id[id].set_cached_children(children)
      end
    end
  end
end

