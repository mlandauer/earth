
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
    has_many :files, :class_name => "Earth::File", :dependent => :delete_cascade, :order => :name, :extend => Earth::FilesExtension
    has_many :cached_sizes, :class_name => "Earth::CachedSize", :dependent => :delete_cascade
    has_many :filters, :class_name => "Earth::Filter", :through => :cached_sizes
    belongs_to :server

    after_save("self.observe_after_save; true")

    @@save_observers = []
  
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
      @cached_size || size_with_filter || sum_files(:size)
    end

    def size_with_filter
      filter = Thread.current[:with_filter]
      cached_size = cached_sizes.find :first, :conditions => ["filter_id = ?", filter.id] if filter
      cached_size.size if cached_size || nil
    end

    def blocks
      @cached_blocks || sum_files(:blocks)
    end

    def sum_files(column)
      Earth::File.sum(column, 
                      :conditions => ("directories.lft >= (SELECT lft FROM #{self.class.table_name} WHERE id=#{self.id}) " + \
                                      " AND directories.lft <= (SELECT rgt FROM #{self.class.table_name} WHERE id=#{self.id}) " + \
                                      " AND directories.server_id = #{self.server_id}"),
                      :joins => "JOIN directories ON files.directory_id = directories.id").to_i
    end

    #
    # Set the recursive size 
    #
    def cached_size= (cached_size)
      @cached_size = cached_size
    end
    
    def recursive_file_count
      Earth::File.count(:conditions => ("directories.lft >= (SELECT lft FROM #{self.class.table_name} WHERE id=#{self.id}) " + \
                                        " AND directories.lft <= (SELECT rgt FROM #{self.class.table_name} WHERE id=#{self.id}) " + \
                                        " AND directories.server_id = #{self.server_id}"),
                        :joins => "JOIN directories ON files.directory_id = directories.id").to_i
    end

    def size_and_count
      sum_and_count_files(:size)
    end

    def blocks_and_count
      sum_and_count_files(:blocks)
    end

    def sum_and_count_files(column)
      result = Earth::File.find(:first, 
                                :select => "SUM(files.#{column.to_s}) AS sum, COUNT(*) AS count",
                                :joins => "JOIN directories ON files.directory_id = directories.id",
                                :conditions => ("directories.lft >= (SELECT lft FROM #{self.class.table_name} WHERE id=#{self.id}) " + \
                                                " AND directories.lft <= (SELECT rgt FROM #{self.class.table_name} WHERE id=#{self.id}) " + \
                                                " AND directories.server_id = #{self.server_id}"))
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
    
    # This assumes there are no overlapping directory trees
    def Directory.find_by_path(path)
      return Directory.find(:first, :conditions => ['path = ?', path])
    end
    
    # Returns the child of this directory with the given name
    def find_by_child_name(n)
      Directory.find(:first, :conditions => ['parent_id = ? AND name = ?', id, n])
    end
    
    # Iterate over each node of the tree. Move from the top to the
    # bottom of the tree
    def each
      yield self       
      children.each do |child_node| 
        child_node.each { |e| yield e } 
      end 
    end

    def filter_to_cached_size(id_to_filters)
      cached_sizes = self.cached_sizes
      _filter_to_cached_size = Hash.new

      cached_sizes.each do |cached_size|
        _filter_to_cached_size[id_to_filters[cached_size.filter_id]] = cached_size
      end

      _filter_to_cached_size
    end

    def find_cached_size_by_filter(filter)
      cached_sizes.find(:first, :conditions => ['filter_id = ?', filter.id])
    end

    def Directory.add_save_observer(observer)
      @@save_observers = [] unless @@save_observers
      @@save_observers << observer
    end

    def Directory.remove_save_observer(observer)
      @@save_observers.delete(observer)
    end

    def observe_after_save
      if @@save_observers
        @@save_observers.each do |save_observer|
          save_observer.directory_saved(self)
        end
      end
    end

    def self_and_ancestors_up_to(other)
      result = []
      self_and_ancestors.each do |directory|
        if directory != other
          result << directory
        else
          return result
        end
      end
      result
    end
  end
end

