require 'csv'
require 'pp'

class BrowserController < ApplicationController
  def index
    redirect_to :action => 'show'
  end

  def show
    @server = Earth::Server.find_by_name(params[:server]) if params[:server]
    @directory = @server.directories.find_by_path(params[:path].to_s) if @server && params[:path]
    # Filter parameters
    @show_empty = params[:show_empty]
    @filter_filename = params[:filter_filename]
    if @filter_filename.nil? || @filter_filename == ""
      @filter_filename = "*"
    end
    @filter_user = params[:filter_user]
    
    @users = User.find_all
    
    if @filter_user && @filter_user != ""    
      filter_conditions = ["files.name LIKE ? AND files.uid = ?", @filter_filename.tr('*', '%'),
        User.find_by_name(@filter_user).uid]
    elsif @filter_filename != '*'
      filter_conditions = ["files.name LIKE ?", @filter_filename.tr('*', '%')]
    else
      filter_conditions = nil
    end
    
    Earth::File.with_scope(:find => {:conditions => filter_conditions}) do
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

        # Remove any nil entries resulting from empty directories
        @directories_and_size.delete_if { |entry| entry.nil? }

        # Since we know the parent of each directory found (it is the
        # directory we've been called for, set the known parent path
        # for each directory found. If we don't do this, there'll be
        # another query for each found directory when directory.path
        # is invoked.
        if @directory
          @directories_and_size.each { |entry| entry[0].set_parent_path(@directory.path) }
        end
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
            csv << [directory.name, size.to_i]
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
