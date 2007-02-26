
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

    after_update("self.update_caches; true")
    after_create("self.create_caches; true")

    @@save_observers = []
    @@cache_enabled = true
    cattr_accessor :cache_enabled

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
    def size
      size, blocks, count = size_blocks_and_count
      size
    end
    
    def blocks
      size, blocks, count = size_blocks_and_count
      blocks
    end
        
    def recursive_file_count
      size, blocks, count = size_blocks_and_count
      count
    end

    # This only requires the id of the current directory and so it doesn't matter
    # if the lft and rgt values of the object in memory is out-of-date with the db state
    def size_blocks_and_count
      result = Earth::File.find(:first, 
                                :select => "SUM(files.size) AS sum_size, SUM(files.blocks) AS sum_blocks, COUNT(*) AS count",
                                :joins => "JOIN directories ON files.directory_id = directories.id",
                                :conditions => [ 
                                  "directories.lft >= (SELECT lft FROM #{self.class.table_name} WHERE id = ?) " + \
                                  " AND directories.lft <= (SELECT rgt FROM #{self.class.table_name} WHERE id = ?) " + \
                                  " AND directories.server_id = ?",
                                  self.id,
                                  self.id,
                                  self.server_id,
                                ])
      [ (result["sum_size"] || 0).to_i, (result["sum_blocks"] || 0).to_i, result["count"].to_i ]
    end

    def recursive_cache_count
      first_filter = Earth::Filter::find(:first)
      Earth::CachedSize.count(:conditions => [
                                "directories.lft >= (SELECT lft FROM #{self.class.table_name} WHERE id = ?) " + \
                                " AND directories.lft <= (SELECT rgt FROM #{self.class.table_name} WHERE id = ?) " + \
                                " AND directories.server_id = ?" + \
                                " AND filter_id = ?", \
                                self.id,
                                self.id,
                                self.server_id,
                                first_filter.id],
                              :joins => "JOIN directories ON cached_sizes.directory_id = directories.id").to_i
    end
    
    def recursive_directory_count
      return 1 + children_count
    end

    # Set the recursive size
    def cached_size= (cached_size)
      @cached_size = cached_size
    end
    
    # Add caching to recursive_file_count, size_blocks_and_count, size and blocks
    def recursive_file_count_with_caching
      cache_data(:count) || recursive_file_count_without_caching
    end
    
    def size_blocks_and_count_with_caching
      cache_data(:size, :blocks, :count) || size_blocks_and_count_without_caching
    end

    def size_with_caching
      @cached_size || cache_data(:size) || size_without_caching
    end
        
    def blocks_with_caching
      cache_data(:blocks) || blocks_without_caching
    end

    alias_method_chain :recursive_file_count, :caching
    alias_method_chain :size_blocks_and_count, :caching
    alias_method_chain :size, :caching
    alias_method_chain :blocks, :caching

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

    def cache_complete?
      return recursive_cache_count == recursive_directory_count
    end
    
    def update_caches
      return unless cache_enabled
      
      # content of cached_sizes can be invalidated by updating the size of
      # another directory, so it should be reloaded from the db before it's used
      cached_sizes.reload
      cached_sizes.each do |cached_size|
        filter = cached_size.filter
        size, blocks, count = 0, 0, 0
        self.children.each do |child|
          child_cached_size = child.find_cached_size_by_filter(filter)
          if child_cached_size
            size += child_cached_size.size
            blocks += child_cached_size.blocks
            count += child_cached_size.count
          end
        end

        self.files.each do |file|
          if filter.matches(file) then
            size += file.size
            blocks += file.blocks
            count += 1
          end
        end

        increase_cached_sizes_of_self_and_ancestors(filter, size - cached_size.size,
          blocks - cached_size.blocks, count - cached_size.count)
      end
    end

    def create_caches
      return unless cache_enabled

      # See comment in method update_caches
      cached_sizes.reload
      existing_filters = cached_sizes.map { |cached_size| cached_size.filter }
      Earth::Filter::find(:all).each do |filter|
        if not existing_filters.include?(filter) then
          cached_sizes.create(:directory => self, :filter => filter)
        end
      end
    end

  private
    def increase_cached_sizes_of_self_and_ancestors(filter, size_increase, blocks_increase, count_increase)
      if size_increase != 0 or blocks_increase != 0 or count_increase != 0
        Earth::CachedSize.update_all([
                                       "size = size + ?, blocks = blocks + ?, count = count + ?",
                                       size_increase, blocks_increase, count_increase 
                                     ],
                                     [
                                       "filter_id = ? and directory_id in (?)",
                                       filter, self.self_and_ancestors
                                     ])
      end    
    end
    
    def cache_data(*columns)
      filter = Thread.current[:with_filter]
      cached_size = cached_sizes.find :first, :conditions => ["filter_id = ?", filter.id] if filter
      if cached_size
        if columns.size > 1
          columns.map { |column| cached_size[column] }
        else
          cached_size[columns[0]]
        end
      end
    end
  end
end

