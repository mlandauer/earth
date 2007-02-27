class GraphController < ApplicationController

  # TODO:
  #
  # subdirectories for "n directories"
  # in server view, show segments for directories
  # mark files with hatched background (optional; more generally, more useful color coding?)
  # fading edge one level darker (?)


  include ApplicationHelper

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

        @directory.cache_sizes_recursive(@level_count)

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

end
