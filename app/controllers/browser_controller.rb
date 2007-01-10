require 'csv'

class BrowserController < ApplicationController
  def index
    redirect_to :action => 'show'
  end

  def show
    @server = Earth::Server.find_by_name(params[:server]) if params[:server]
    @directory = @server.directories.find_by_path(params[:path].to_s) if @server && params[:path]
    @show_empty = params[:show_empty]
    @filter_filename = params[:filter_filename]
    if @filter_filename.nil? || @filter_filename == ""
      @filter_filename = "*"
    end

    # if at the root
    if @server.nil?
      @servers = Earth::Server.find(:all)
    # if at the root of a server
    elsif @server && @directory.nil?
      @directories = Earth::Directory.roots_for_server(@server)
    # if in a directory on a server
    elsif @server && @directory
      @directories = @directory.children
      @files = Earth::File.find(:all, :conditions => ['directory_id = ? AND name LIKE ?', @directory.id, @filter_filename.tr('*', '%')])
    end
    
    # Filter out servers and directories that have no files
    if @show_empty.nil?
      @servers = @servers.select{|s| s.has_files?(@filter_filename)} if @servers
      @directories = @directories.select{|s| s.has_files?(@filter_filename)} if @directories
    end
    
    respond_to do |wants|
      wants.html
      wants.xml {render :action => "show.rxml", :layout => false}
      wants.csv do
        @csv_report = StringIO.new
        CSV::Writer.generate(@csv_report, ',') do |csv|
          csv << ['Directory', 'Size (bytes)']
          for directory in @directories
            csv << [directory.name, directory.recursive_size]
          end
        end
        
        @csv_report.rewind
        send_data(@csv_report.read, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => 'earth_report.csv', :disposition => 'downloaded')
      end
    end
  end
  
private
  def glob2pat(globstr)
      patmap = {
          '*' => '.*',
          '?' => '.',
          '[' => '[',
          ']' => ']',
      }
      globstr.gsub!(/(.)/) { |c| patmap[c] || Regexp::escape(c) }
      '^' + globstr + '$'
  end
end
