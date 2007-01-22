# TODO:
#
# subdirectories for "n directories"
# in server view, show segments for directories
# use filters
# test server views with good test data
# mark files with hatched background (optional; more generally, more useful color coding?)
# make stuff configurable - minimum angle, etc.
# fix double-slash in top-level file tooltip
# better tooltips for "other files", "other directories" (include total size, relative parent directory)
# why is there "1 directories" here:?? http://localhost:3000/graph?server=powerbook-2.local&path=/Volumes/Shared/eclipse/plugins/org.eclipse.rcp.source_3.1.1/src
# grey fading lines
# fading edge one level darker

class GraphController < ApplicationController

  include ApplicationHelper

  def initialize
    @level_count = @@webapp_config["graph_depth"]
  end

  def index
    @server = Earth::Server.find_by_name(params[:server]) if params[:server]
    @directory = @server.directories.find_by_path(params[:path].to_s) if @server && params[:path]
  end

  def show
    @server = Earth::Server.find_by_name(params[:server]) if params[:server]
    @directory = @server.directories.find_by_path(params[:path].to_s) if @server && params[:path]

    if @server

      if @directory.nil?

        roots = Earth::Directory.roots_for_server(@server)
        roots.each do |root|
          root.load_all_children(@level_count - 1)
        end

        @directory = Earth::Directory.new(:name => @server.name, :children => roots, :level => 0)

      elsif false
        # This is more efficient for two reasons: firstly, the
        # :include => files approach used below will use a join, which
        # means that redundant data is returned from the database
        # (duplicate directory rows joined into the file rows.)
        # Secondly, we don't need the files for the lowest level in
        # the hierarchy, but they are included anyway with the
        # :include. This approach however is less straightforward and
        # requires tweaking directory's files member so that cached
        # files are returned instead of a redundant query.
        @directory.load_all_children(@level_count)

        files = Earth::File.find(:all, 
                                 :conditions => "directory_id IN (SELECT id FROM directories " +
                                 "WHERE level<#{@directory.level + @level_count} " +
                                 " AND server_id=#{@server.id} " +
                                 " AND lft >= #{@directory.lft} " +
                                 " AND rgt <= #{@directory.rgt})")
        
        @directory_to_file_map = Hash.new
        files.each do |file|
          if not @directory_to_file_map.has_key?(file.directory_id) then
            @directory_to_file_map[file.directory_id] = Array.new
          end
          @directory_to_file_map[file.directory_id] << file
        end

        # FIXME: if this is enabled, the map contents need to be
        # attached to the directory nodes so that directory.files
        # returns the cached files without another query; and the
        # directory.files of all directories not in the map need to be
        # set to [] so that accessing them doesn't trigger a query.
      else
        @directory.load_all_children(@level_count, :include => :files)
      end

      @directory_size_map = Hash.new
      gather_directory_sizes_pass_1(@directory, @directory.level + @level_count)
      gather_directory_sizes_pass_2(@directory, @directory.level + @level_count)

      render :layout => false, :action => "directory.rxml"
    else
      @servers = Earth::Server.find(:all).select{|s| s.has_files?}
      render :layout => false, :action => "servers.rxml"
    end
  end

private

  def gather_directory_sizes_pass_1(directory, leaf_level)
    if directory.level == leaf_level
      @directory_size_map[directory.id] = directory.size
    else
      @directory_size_map[directory.id] = 0
        directory.files.each do |file|
          @directory_size_map[directory.id] += file.size
      end
      directory.children.each do |child|
        if not directory.id.nil?
          child.set_parent_path(directory.path)
        else
          child.set_parent_path("")
        end
        gather_directory_sizes_pass_1(child, leaf_level)
      end
    end
  end

  def gather_directory_sizes_pass_2(directory, leaf_level)
    if directory.level != leaf_level
      directory.children.each do |child|
        gather_directory_sizes_pass_2(child, leaf_level)
        @directory_size_map[directory.id] += @directory_size_map[child.id]
      end
      directory.cached_size = @directory_size_map[directory.id]
    end
  end

end
