class DirectoriesController < ApplicationController
  model :directory, :archive
  layout 'master'
  # caches_page :show_xml

  def initialize
    # So far we are only working with "one serie" and we therefor
    # only support the following 4 graph types.
    @@charts = {
      "2D Column"  => "FC_2_3_Column2D",
      "2D Pie"     => "FC_2_3_Pie2D",
      "3D Column"  => "FC_2_3_Column3D",
      "3D Pie"     => "FC_2_3_Pie3D"
    }
  end

  def index
  end
  
  def flash_graph
    session[:graph_type] = @@charts[ @params[:graph_type] ] unless @params[:graph_type].nil?
    render_without_layout
  end

  def show_xml
    # We use sessions to share the data from the "show" method so
    # we don't hit the DB again to generate the XML that the graph
    # uses
    unless session[:subdirectories].nil?
      size_for_scale = 0
      session[:subdirectories].each { |entry|
        entry.each { |key, value|
          size_for_scale += value          
        }
      }
      size_for_scale_avg = (size_for_scale / session[:subdirectories].length)
      @scaled_size = get_human_size(size_for_scale_avg)
      size_modifier = get_size_modifier(size_for_scale_avg)
      @root = session[:root]
      @server = session[:server]
      @elements = Array.new
      session[:subdirectories].each { |subdirectory|
        subdirectory.each { |key, value|
          # We normalise the "value" which holds the size for the directory
          # to something easier to display
          @elements<< { 'name' => key, 'value' => (value / size_modifier) }
        }
      }
    end
    render_without_layout
  end
  
  def show
    if session[:graph_type].nil?
      # Default graph type is 2D Column
      session[:graph_type] = @@charts["2D Column"]
    end
    if @params[:obs] and @params[:server]
      @server = @params[:server]
      @root = @params[:obs]
      subdirectories = Hash.new
      session[:root] = @root
      session[:server] = @server
      session[:subdirectories] = Array.new
      Directory.size_children(@server, @root).each { |c|
        subdirectories[ c.path ] = c.storage.to_i.kilobytes
        session[:subdirectories]<< { c.path => c.storage.to_i.kilobytes }
      }
      # Sort subdirectories by size (desc)
      my_children_to_sort = subdirectories.sort { |a,b|
        b[1] <=> a[1]
      }
      # We use an array because a Hash is not navigated based on insertion
      # order, and we need that on the display.
      @my_children = Array.new
      my_children_to_sort.each { |child|
        # child[0] contains the path
        # child[1] contains the storage
        @my_children<< { child[0] => child[1] }
      }
    elsif @params[:obs] and @params[:server].nil?
      # We can't represent this
      redirect_to :action => 'show'
    elsif @params[:obs].nil? and @params[:server]
      redirect_to :action => 'show', :server => @params[:server], :obs => "/"
    else
      # First time we hit this page or nothing set. let's show the top
      # servers
      @server = ""
      @root = ""
      subdirectories = Hash.new
      session[:root] = @root
      session[:server] = ""
      session[:subdirectories] = Array.new
      servers = Directory.find_by_sql(" SELECT SUM(filesize) as storage, server \
                                        FROM directories GROUP BY server")
      servers.each { |s|
        subdirectories[ s.server ] = s.storage.to_i.kilobytes
        session[:subdirectories]<< { s.server => s.storage.to_i.kilobytes }
      }
      # Sort subdirectories by size (desc)
      my_children_to_sort = subdirectories.sort { |a,b|
        b[1] <=> a[1]
      }
      # We use an array because a Hash is not navigated based on insertion
      # order, and we need that on the display.
      @my_children = Array.new
      my_children_to_sort.each { |child|
        # child[0] contains the path
        # child[1] contains the storage
        @my_children<< { child[0] => child[1]  }
      }
    end
  end

  def reports
    @servers =  [["ikea", "ikea"], ["freedom", "freedom"]]
  end
  
  def report_show
    if @params[:report][:server]
      # get_report(server, observation_point, startdate, enddate)
      startdate = 2.weeks.ago.to_date
      enddate = Date.today
      @report_data = Archive.get_report(@params[:report][:server], @params[:report][:filter], startdate, enddate)
      session[:period] = "2 weeks"
      session[:report_xml] = @report_data
      render_without_layout
    end
  end
  
  def report_xml
    size_for_scale = 0
    session[:report_xml].each { |entry|
      size_for_scale += entry.storage.to_i
    }
    size_for_scale_avg = (size_for_scale / session[:report_xml].length)
    @scaled_size = get_human_size(size_for_scale_avg.kilobytes)
    size_modifier = get_size_modifier(size_for_scale_avg)
    
    @report_data = session[:report_xml]
    # Colours
    @colours = ["0080C0", "808080", "800080", "FF8040", "FFFF00", "FF0080", "0082C0", "0F80C0", "F0A0C0", "CACA00", "FF00FF"]
    # Since we use the days as the categories, let's generate a @categories
    @categories = Array.new
    @datasets = Hash.new
    @report_data.each { |r|
      @datasets[ r.observation ] = Array.new unless @datasets.has_key?( r.observation )
      # We normalize the storage by the average
      @datasets[ r.observation ]<< (r.storage.to_i / size_modifier)
      @categories<< r.observed unless @categories.include?(r.observed)
    }
    render_without_layout
  end
  
  def report_flash_graph
    render_without_layout
  end
  
  def growers
    # Place holder that presents the AJAX form
    # I know this sucks ... but using hardcoded servers makes this
    # faster and canopy is not here to stay ... or is it? ;-)
    @servers = ["ikea", "freedom"]
    @period = [["Yesterday", 1], ["2 Days ago", 2], ["Last Week", 7], ["Last Two Weeks", 14]]
    @limits = [["10", 10], ["20", 20], ["30", 30], ["40", 40], ["50", 50]]
  end
  
  def growers_show
    # TODO: check that we don't get crap in these parameters
    @server = @params[:growers][:server]
    @observation_point = @params[:growers][:obs]
    period = @params[:growers][:period]
    @before = period.to_i.days.ago.to_date.to_s
    @after = Date.today.to_s
    @limit = @params[:growers][:limit]
    @top_growers = Archive.get_top_growers(@server, @observation_point, @before, @after, @limit)
    render_without_layout    
  end
  
  protected

  # Our own modified versions which are not used to display in a nice
  # human size but will tell us within which range our size is and
  # the second one (get_size_modifier) is used to divide the results
  # for the flash graphs so that they are not cluttered and are in the
  # best range for display

    def get_human_size(size)
      begin
        return "Bytes" % size               if size < 1.kilobytes
        return "KB" % (size/1.0.kilobytes)  if size < 1.megabytes
        return "MB" % (size/1.0.megabytes)  if size < 1.gigabytes
        return "GB" % (size/1.0.gigabytes)  if size < 1.terabytes
        return "TB" % (size/1.0.terabytes) 
      rescue
        # just return nothing
      end
    end

    def get_size_modifier(size)
      begin
        return 1.byte       if size < 1.kilobytes
        return 1.kilobyte   if size < 1.megabytes
        return 1.0.megabyte if size < 1.gigabytes
        return 1.0.gigabyte if size < 1.terabytes
        return 1.0.terabyte 
      rescue
        # just return nothing
      end
    end

  
end
