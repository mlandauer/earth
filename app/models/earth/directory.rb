
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
      self.modified = stat.mtime.utc unless stat.nil?
    end
    
    # Returns a "fake" Stat object with some of the same information as File::Stat
    def stat
      Stat.new(modified) unless modified.nil?
    end

    # The size (in bytes and blocks) and the number of files recursively contained in this directory
    # This only requires the id of the current directory and so it doesn't matter
    # if the lft and rgt values of the object in memory is out-of-date with the db state
    def size
      result = Earth::File.find(:first, 
                                :select => "SUM(files.bytes) AS sum_bytes, SUM(files.blocks) AS sum_blocks, COUNT(*) AS count",
                                :joins => "JOIN directories ON files.directory_id = directories.id",
                                :conditions => [ 
                                  "directories.lft >= (SELECT lft FROM #{self.class.table_name} WHERE id = ?) " + \
                                  " AND directories.lft <= (SELECT rgt FROM #{self.class.table_name} WHERE id = ?) " + \
                                  " AND directories.server_id = ?",
                                  self.id,
                                  self.id,
                                  self.server_id,
                                ])
      Size.new((result["sum_bytes"] || 0).to_i, (result["sum_blocks"] || 0).to_i, result["count"].to_i)
    end

    def recursive_cache_count
      Earth::CachedSize.count(:conditions => [
                                "directories.lft >= (SELECT lft FROM #{self.class.table_name} WHERE id = ?) " + \
                                " AND directories.lft <= (SELECT rgt FROM #{self.class.table_name} WHERE id = ?) " + \
                                " AND directories.server_id = ?", \
                                self.id,
                                self.id,
                                self.server_id],
                              :joins => "JOIN directories ON cached_sizes.directory_id = directories.id").to_i
    end
    
    # Returns all files belonging to sub-directories of the current directory
    # down to the given level (including that level)
    def find_files_down_to_level(level)
      Earth::File.find(:all, :conditions => [ 
        "directory_id IN (SELECT id FROM directories " + \
                                 "WHERE level <= ? " + \
                                 " AND server_id = ? " + \
                                 " AND lft >= ? " + \
                                 " AND rgt <= ?)",
                                 level, self.server_id, self.lft, self.rgt ])
    end
    
    # Walk the in-memory tree
    def find_subdirectories_at_level(level)
      if self.level == level
        [self]
      else
        children.map{|c| c.find_subdirectories_at_level(level)}.flatten
      end
    end
    
    def recursive_directory_count
      return 1 + children_count
    end
    
    def size_with_caching
      if @cached_size
        @cached_size
      elsif Thread.current[:with_filtering].nil? && cached_sizes.find(:first)
        cached_sizes.find(:first).size
      else
        size_without_caching
      end
    end
    alias_method_chain :size, :caching

    def has_files?
      size.count > 0
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
    
    # Iterate over each node of the tree. Move from the top to the
    # bottom of the tree
    def each
      yield self       
      children.each do |child_node| 
        child_node.each { |e| yield e } 
      end 
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
      
      # content of cached_sizes can be invalidated by updating the
      # size of another directory, so it should be reloaded from the
      # db before it's used.  It might also have not yet been created
      # (because cache_enabled was set to false and the daemon was
      # cancelled before bulk cache creation.)  Therefore, invoke
      # create_cached to make sure the cache exists and is up-to-date.
      create_caches

      cached_sizes.each do |cached_size|
        size = Size.new(0, 0, 0)
        self.children.each do |child|
          child_cached_size = child.cached_sizes.find(:first)
          if child_cached_size
            size += child_cached_size.size
          end
        end

        self.files.each do |file|
          size += file.size
        end

        increase_cached_sizes_of_self_and_ancestors(size - cached_size)
      end
    end

    def create_caches
      return unless cache_enabled

      # See comment in method update_caches
      cached_sizes.reload
      if cached_sizes.empty?
        cached_sizes.create(:directory => self)
      end
    end
    
    # Starting at the top of the directory structure create the caches (and make them up-to-date)
    # for everything recursively below this directory
    # Returns the current cached size of this directory
    def create_caches_recursively(eta_printer = nil)
      if not cached_sizes.loaded? or cached_sizes.empty?
        cached_size = cached_sizes.new(:directory => self)
  
        children.each do |child|
          cached_size.size += child.create_caches_recursively(eta_printer)
        end
  
        files.each do |file|
          cached_size.size += file.size
        end
        files.reset
  
        cached_size.create
        eta_printer.increment if eta_printer
      else
        cached_size = cached_sizes[0]
      end
      cached_size.size
    end
    
    # Fetch all the files and precache them into the association "files" for all 
    # directories below this one, down to and including the given level
    # The clever bit is that we fetch all the files in one go (in a single SQL select)
    def cache_files_down_to_level(level)
      files = find_files_down_to_level(level)

      # Sort the files by directory
      directory_to_file_map = Hash.new
      files.each do |file|
        if not directory_to_file_map.has_key?(file.directory_id) then
          directory_to_file_map[file.directory_id] = Array.new
        end
        directory_to_file_map[file.directory_id] << file
      end

      # Uses the @directory_to_file_map to set the "files"
      # collection for each directory node, recursively.
      set_files_recursive(directory_to_file_map)
    end
    
    #
    # The maximum size we allow for the huge CASE WHEN... WHEN... ELSE
    # END construct for getting cumulative sizes for multiple
    # directories in one go. This is meant to prevent the SQL statement
    # to become too long. Most databases support statements up to 8192
    # bytes - setting this to 7000 leaves plenty of room for the other
    # components of the query.
    #
    # Set to 0 to never use the case construct.
    MAXIMUM_SELECT_CASE_SIZE = 7000

    #
    # Cache recursive size information for "depth" levels under this
    # directory node.
    #
    def cache_sizes_recursive(depth)
      leaf_level = self.level + depth

      # We only need to cache the files to the level above the leaf level
      cache_files_down_to_level(leaf_level - 1)

      # Now determine cumulative size of each directory
      directory_size_map = Hash.new
      
      # We only need to grab the cumulative size of directories on
      # the leaf level from the database; since we already have all
      # files on higher levels, we can calculate the cumulative size
      # of directories on higher levels from in-memory data
      # afterwards.

      # If there is cached information for the currently active
      # filter, grab size information from the cache.
      # Otherwise we need to calculate it from the files table.
      if Thread.current[:with_filtering].nil?
        cached_sizes = Earth::CachedSize.find(:all,
          :conditions => {:directory_id => find_subdirectories_at_level(leaf_level).map{|d| d.id}})

        # Use the cached sizes to fill in data for the leaf directories
        cached_sizes.each do |cached_size|
          directory_size_map[cached_size.directory_id] = cached_size.size
        end

      else
        # No cached information for the active filter - we need to
        # recursively determine the size of each leaf-level
        # directory.

        # The following grabs the cumulative size of all directories
        # on the leaf level in an optimized fashion with a single
        # SQL SELECT statement.

        # Start by getting the ids and left-edge values for each
        # directory on the leaf level.

        edges = find_subdirectories_at_level(leaf_level)

        # If the query didn't return any information, there are no
        # directories on the leaf level and we don't need to bother.
        if not edges.empty?

          # Keep track of all directories on the leaf level so we
          # know which ones are empty. We need to do that because we
          # can't construct the SELECT statement in a way that
          # returns 0-size for empty directories (instead, empty
          # directories just won't show up in the result set.)
          directory_id_set = Set.new

          # Assemble a CASE statement that's used for determining
          # the leaf-level directory id from the left edge value of
          # a directory found recursively. This is used for grouping
          # (summarizing) results by leaf-level directory.
          edge_case = "CASE ";
          edges.sort_by{|e| e.lft}.reverse.each do |edge_info|
            id = edge_info['id'].to_i
            edge_case += "WHEN lft >= #{edge_info['lft'].to_i} THEN #{id} "
            directory_id_set << id # Remember leaf level directory
          end
          edge_case += "END"

          # If the case construct became too big, replace it with a
          # (less efficient) dynamic query that works for any amount
          # of directories.
          #
          # FIXME: instead of doing this after the fact, it would be
          # more efficient to avoid building the CASE statement in
          # the first place. However, in that case we can't work
          # with the maximum SQL query size as conveniently. This is
          # a bit slower but safer.
          if edge_case.size > MAXIMUM_SELECT_CASE_SIZE
            edge_case = "(SELECT id from directories AS dirs WHERE level = #{self.level + depth} AND directories.lft >= dirs.lft and directories.lft <= dirs.rgt)"
          end
          
          # Grab cumulative size per leaf-level directory from the
          # database in one go.
          size_infos = Earth::File.find(:all, 
                                        :select => ("SUM(bytes) AS sum_bytes, SUM(blocks) AS sum_blocks, COUNT(*) AS count, #{edge_case} AS dir_id"),
                                        :joins => "JOIN directories ON files.directory_id = directories.id",
                                        :conditions => [ 
                                          "directories.level >= ? " + \
                                          " AND directories.server_id = ? " + \
                                          " AND directories.lft >= ? " + \
                                          " AND directories.lft <= ?",
                                          leaf_level,
                                          self.server_id,
                                          self.lft,
                                          self.rgt
                                        ],
                                        :group => "dir_id")
          
          # Put non-empty directories into the map
          size_infos.each do |size_info|
            bytes = size_info["sum_bytes"].to_i
            blocks = size_info["sum_blocks"].to_i
            count = size_info["sum_count"].to_i
            directory_id = size_info["dir_id"].to_i
            directory_size_map[directory_id] = Size.new(bytes, blocks, count)

            # Remove leaf level directory for which we got size
            # information, leaving only empty directories in the set
            directory_id_set.delete(directory_id) 
          end

          # Put empty directories into the map
          directory_id_set.each do |empty_directory_id|
            directory_size_map[empty_directory_id] = Size.new(0, 0, 0)
          end
        end
      end

      # The following calculates the size of all remaining (inner)
      # directories recursively by using the sizes of files and
      # leaf-level directories, and caches the size information
      # in each directory.
      
      compute_cached_size_recursive(self.level + depth, directory_size_map)
      set_cached_size_recursive(self.level + depth, directory_size_map)

      # Done: For each directory up to @level_count levels under the
      # current directory, the files and size getters can now be
      # used without triggering a database query.
    end

  private
    def increase_cached_sizes_of_self_and_ancestors(size_increase)
      if size_increase != Size.new(0, 0, 0)
        Earth::CachedSize.update_all(["bytes = bytes + ?, blocks = blocks + ?, count = count + ?",
                                       size_increase.bytes, size_increase.blocks, size_increase.count],
                                     ["directory_id in (?)", self.self_and_ancestors])
      end    
    end
    
    protected
    def set_files_recursive(directory_to_file_map)
      if directory_to_file_map.has_key?(self.id)
        self.files.set(directory_to_file_map[self.id])
      else
        self.files.set([])
      end
      self.children.each do |child|
        child.set_files_recursive(directory_to_file_map)
      end
    end

    def compute_cached_size_recursive(leaf_level, directory_size_map)
      if self.level < leaf_level
        directory_size_map[self.id] = Size.new(0, 0, 0)
        self.files.each do |file|
          directory_size_map[self.id] += file.size
        end
        self.children.each do |child|
          child.compute_cached_size_recursive(leaf_level, directory_size_map)
        end
      else
        if not directory_size_map.has_key?(self.id)
          directory_size_map[self.id] = self.size
        end
      end
    end

    def set_cached_size_recursive(leaf_level, directory_size_map)
      if self.level != leaf_level
        self.children.each do |child|
          child.set_cached_size_recursive(leaf_level, directory_size_map)
          directory_size_map[self.id] += directory_size_map[child.id]
        end
      end
      @cached_size = directory_size_map[self.id]
    end
  end
end

