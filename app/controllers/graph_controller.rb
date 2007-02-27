class GraphController < ApplicationController

  # TODO:
  #
  # subdirectories for "n directories"
  # in server view, show segments for directories
  # mark files with hatched background (optional; more generally, more useful color coding?)
  # fading edge one level darker (?)


  include ApplicationHelper

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
  #  Initialize the graph controller instance by looking up
  #  configuration data from earth-webapp.yml
  #
  def initialize
    @level_count = @@webapp_config["graph_depth"]
    @minimum_angle = @@webapp_config["graph_min_angle"]
    @remainder_mode = @@webapp_config["graph_remainder_mode"].to_sym
    @coloring_mode = @@webapp_config["graph_coloring_mode"].to_sym
  end

  #
  # The "index" action.  Gathers data for the "index.rhtml" view which shows
  # navigation elements and loads the SVG file.
  #
  def index
    @svg_params = Hash.new
    @svg_params.update(params)
    @svg_params.delete(:action)
    @svg_params.delete(:controller)
    @svg_params.delete("action")
    @svg_params.delete("controller")

    @server = Earth::Server.find_by_name(params[:server]) if params[:server]
    @directory = @server.directories.find_by_path(params[:path].to_s) if @server && params[:path]

    @any_empty = false

    @browser_warning = ApplicationHelper::get_browser_warning(request)
  end

  #
  #  The "show" action.  Gathers data for and redirects to either the
  #  "directories.rxml" or "servers.rxml" view, depending on whether a
  #  directory has been specified in the parameters.
  #
  def show
    @server = Earth::Server.find_by_name(params[:server]) if params[:server]
    @directory = @server.directories.find_by_path(params[:path].to_s) if @server && params[:path]

    Earth::File.with_filter(params) do
      
      if @server

        if @directory.nil?

          # If we're on the server level, create a "fake" top-level
          # directory and put all roots of the server into it as
          # children.

          roots = Earth::Directory.roots_for_server(@server)
          max_right = 0
          roots.each do |root|
            root.load_all_children(@level_count - 1)
            max_right = [ max_right, root.rgt ].max
          end

          @directory = Earth::Directory.new(:name => @server.name, 
                                            :children => roots, 
                                            :level => 0, 
                                            :server => @server, 
                                            :lft => 0, 
                                            :rgt => max_right + 1
                                            )

        else
          @directory.load_all_children(@level_count)
        end

        # Below, we're fetching recursive file and size information
        # for the given number of levels efficiently, minimizing the
        # number of SQL queries that need to be performed.

        leaf_level = @directory.level + @level_count

        # Grab all files belonging to sub-directories of the current
        # directory, up to the leaf level (exclusive).
        files = Earth::File.find(:all, 
                                 :conditions => [ 
                                   "directory_id IN (SELECT id FROM directories " + \
                                   "WHERE level < ? " + \
                                   " AND server_id = ? " + \
                                   " AND lft >= ? " + \
                                   " AND rgt <= ?)",
                                   leaf_level,
                                   @server.id,
                                   @directory.lft,
                                   @directory.rgt ])

        # Sort the files by directory
        @directory_to_file_map = Hash.new
        files.each do |file|
          if not @directory_to_file_map.has_key?(file.directory_id) then
            @directory_to_file_map[file.directory_id] = Array.new
          end
          @directory_to_file_map[file.directory_id] << file
        end

        # Uses the @directory_to_file_map to set the "files"
        # collection for each directory node, recursively.
        setup_directory(@directory)

        # Now determine cumulative size of each directory

        @directory_size_map = Hash.new

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
                                                :conditions => [ 
                                                  "directory_id IN (SELECT id FROM directories " + \
                                                  "WHERE level = ? " + \
                                                  " AND server_id = ? " + \
                                                  " AND lft >= ? " + \
                                                  " AND rgt <= ?) ", \
                                                  leaf_level,
                                                  @server.id,
                                                  @directory.lft,
                                                  @directory.rgt])

          # Use the cached sizes to fill in data for the leaf directories
          cached_sizes.each do |cached_size|
            @directory_size_map[cached_size.directory_id] = cached_size.size
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

          # FIXME: we already have that information in memory (fetched
          # using load_all_children above). It would be more efficient
          # to walk the in-memory tree under @directory and gather the
          # information from there.
          edges = Earth::Directory.find(:all, 
                                        :select => [ "lft, id" ],
                                        :conditions => [ 
                                          "level = ? AND server_id = ? AND lft >= ? AND lft <= ?",
                                          leaf_level,
                                          @server.id,
                                          @directory.lft,
                                          @directory.rgt,
                                        ],
                                        :order => "lft DESC"
                                        )

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
            edges.each do |edge_info|
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
              edge_case = "(SELECT id from directories AS dirs WHERE level = #{@directory.level + @level_count} AND directories.lft >= dirs.lft and directories.lft <= dirs.rgt)"
            end
            
            # Grab cumulative size per leaf-level directory from the
            # database in one go.
            size_infos = Earth::File.find(:all, 
                                          :select => ("SUM(size) AS sum_size, #{edge_case} AS dir_id"),
                                          :joins => "JOIN directories ON files.directory_id = directories.id",
                                          :conditions => [ 
                                            "directories.level >= ? " + \
                                            " AND directories.server_id = ? " + \
                                            " AND directories.lft >= ? " + \
                                            " AND directories.lft <= ?",
                                            leaf_level,
                                            @server.id,
                                            @directory.lft,
                                            @directory.rgt
                                          ],
                                          :group => "dir_id")
            
            # Put non-empty directories into the map
            size_infos.each do |size_info|
              size = size_info["sum_size"].to_i
              directory_id = size_info["dir_id"].to_i
              @directory_size_map[directory_id] = size

              # Remove leaf level directory for which we got size
              # information, leaving only empty directories in the set
              directory_id_set.delete(directory_id) 
            end

            # Put empty directories into the map
            directory_id_set.each do |empty_directory_id|
              @directory_size_map[empty_directory_id] = 0
            end
          end
        end

        # The following calculates the size of all remaining (inner)
        # directories recursively by using the sizes of files and
        # leaf-level directories, and uses
        # Earth::Directory.cached_size= to put the size information
        # into each directory.
        gather_directory_sizes_pass_1(@directory, @directory.level + @level_count)
        gather_directory_sizes_pass_2(@directory, @directory.level + @level_count)

        # Done: For each directory up to @level_count levels under the
        # current directory, the files and size getters can now be
        # used without triggering a database query.

        if params[:mode] == "treemap"
          render :layout => false, :action => "directory_treemap.rxml"
        else
          render :layout => false, :action => "directory.rxml"
        end
      else
        @servers = Earth::Server.find(:all)
        render :layout => false, :action => "servers.rxml"
      end
    end
  end

private

  def setup_directory(directory)
    if @directory_to_file_map.has_key?(directory.id)
      directory.files.set(@directory_to_file_map[directory.id])
    else
      directory.files.set([])
    end
    directory.children.each do |child|
      setup_directory(child)
    end
  end


  def gather_directory_sizes_pass_1(directory, leaf_level)
    if directory.level < leaf_level
      @directory_size_map[directory.id] = 0
        directory.files.each do |file|
          @directory_size_map[directory.id] += file.size
      end
      directory.children.each do |child|
        gather_directory_sizes_pass_1(child, leaf_level)
      end
    else
      if not @directory_size_map.has_key?(directory.id)
        @directory_size_map[directory.id] = directory.size
      end
    end
  end

  def gather_directory_sizes_pass_2(directory, leaf_level)
    if directory.level != leaf_level
      directory.children.each do |child|
        gather_directory_sizes_pass_2(child, leaf_level)
        @directory_size_map[directory.id] += @directory_size_map[child.id]
      end
    end
    directory.cached_size = @directory_size_map[directory.id]
  end

end
