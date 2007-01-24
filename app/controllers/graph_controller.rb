# TODO:
#
# subdirectories for "n directories"
# in server view, show segments for directories
# test server views with good test data
# mark files with hatched background (optional; more generally, more useful color coding?)
# fading edge one level darker (?)
# checkout inconsitency here: http://localhost:3000/graph/powerbook-2.local/Volumes/Shared/eclipse/plugins?filter_filename=*.jar&filter_user=    --- filter sometimes used, sometimes not?

class GraphController < ApplicationController

  include ApplicationHelper

  def initialize
    @level_count = @@webapp_config["graph_depth"]
    @minimum_angle = @@webapp_config["graph_min_angle"]
    @remainder_mode = @@webapp_config["graph_remainder_mode"].to_sym
    @coloring_mode = @@webapp_config["graph_coloring_mode"].to_sym
  end

  def index
    @svg_params = Hash.new
    @svg_params.update(params)
    @svg_params.delete(:action)
    @svg_params.delete(:controller)
    @svg_params.delete("action")
    @svg_params.delete("controller")

    @server = Earth::Server.find_by_name(params[:server]) if params[:server]
    @directory = @server.directories.find_by_path(params[:path].to_s) if @server && params[:path]
  end

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

  def show
    @server = Earth::Server.find_by_name(params[:server]) if params[:server]
    @directory = @server.directories.find_by_path(params[:path].to_s) if @server && params[:path]

    Earth::File.with_filter(params) do
      
      if @server

        if @directory.nil?

          roots = Earth::Directory.roots_for_server(@server)
          max_right = 0
          roots.each do |root|
            root.load_all_children(@level_count - 1)
            max_right = [ max_right, root.rgt ].max
          end

          @directory = Earth::Directory.new(:name => @server.name, :children => roots, :level => 0, :server => @server, :lft => 0, :rgt => max_right + 1)

        elsif true
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

          setup_directory(@directory)
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
