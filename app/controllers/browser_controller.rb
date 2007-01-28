require 'csv'
require 'pp'

class BrowserController < ApplicationController
  def index
    redirect_to :action => 'show'
  end

  def flat
    @server = Earth::Server.find_by_name(params[:server]) if params[:server]
    @directory = @server.directories.find_by_path(params[:path].to_s) if @server && params[:path]

    @page_size = 25
    @current_page = (params[:page] || 1).to_i

    joins = "JOIN directories ON files.directory_id = directories.id"
    order = "directories.path, files.name"
    include_attributes = [ "name", "directory_id", "modified", "size", "uid" ]
    select = include_attributes.map {|attr| "files.#{attr} as #{attr}" }.join(", ")

    if @directory
      conditions = " directories.server_id=#{@server.id} " +
                   " AND directories.lft >= #{@directory.lft} " +
                   " AND directories.rgt <= #{@directory.rgt}"
    elsif @server
      conditions = " directories.server_id=#{@server.id} "
    else
      conditions = nil
    end

    Earth::File.with_filter(params) do
      file_count = Earth::File.count(:joins => joins, 
                                     :conditions => conditions)
      @page_count = (file_count + @page_size - 1) / @page_size
      

      @files = Earth::File.find(:all, 
                                :select => select,
                                :joins => joins,
                                :conditions => conditions,
                                :order => order,
                                :offset => ((@current_page - 1) * @page_size),
                                :limit => @page_size)
    end
  end

  def show
    @server = Earth::Server.find_by_name(params[:server]) if params[:server]
    @directory = @server.directories.find_by_path(params[:path].to_s) if @server && params[:path]
    # Filter parameters
    @show_empty = params[:show_empty]

    Earth::File.with_filter(params) do
      # if at the root
      if @server.nil?
        servers = Earth::Server.find(:all)
      # if at the root of a server
      elsif @server && @directory.nil?
        directories = Earth::Directory.roots_for_server(@server)
      # if in a directory on a server
      elsif @server && @directory
        directories = @directory.children
        # Scoping appears to not work on associations so doing the find explicitly
        @files = Earth::File.find(:all, :conditions => ['directory_id = ?', @directory.id])
      end
      
      # Filter out servers and directories that have no files, query sizes
      if servers
        if @show_empty.nil?
          servers = servers.select{|s| s.has_files?} if servers
        end
        @servers_and_size = servers.map{|s| [s, s.size]} if servers
        @any_empty = @servers_and_size.any? { |server_and_size| server_and_size[1] == 0 }
      elsif directories
        # Instead of filtering out empty directories ahead of time,
        # which requires one additional query per directory, get
        # directory size and file count for each directory in one go
        # and filter out empty directories after the fact
        @directories_and_size = directories.map do |d| 
          size, count = d.size_and_count; 
          if @show_empty || count > 0
            [d, size]
          end
        end

        @any_empty = @directories_and_size.any? { |directory_and_size| directory_and_size && directory_and_size[1] == 0 }
        @any_empty = @files.any? { |file| file.size == 0 } if @files and not @any_empty

        # Remove any nil entries resulting from empty directories
        @directories_and_size.delete_if { |entry| entry.nil? }
      end
    end
    
    respond_to do |wants|
      wants.html
      wants.xml {render :action => "show.rxml", :layout => false}
      wants.csv do
        @csv_report = StringIO.new
        CSV::Writer.generate(@csv_report, ',') do |csv|
          csv << ['Directory', 'Size (bytes)']
          for directory, size in @directories_and_size
            csv << [directory.name, size]
          end
        end
        
        @csv_report.rewind
        send_data(@csv_report.read, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => 'earth_report.csv', :disposition => 'downloaded')
      end

      logger.debug("end of controller")
    end
  end
  
  def auto_complete_for_filter_user
    if User.ldap_configured?
      @users = User.find_matching(params[:filter_user])
      render :inline => '<%= content_tag("ul", @users.map { |user| content_tag("li", h(user.name)) })%>'
    end
  end
end
