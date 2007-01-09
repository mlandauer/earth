require 'csv'

class BrowserController < ApplicationController
  def index
    redirect_to :action => 'show'
  end

  def show
    if params[:server]
      @server = Earth::Server.find_by_name(params[:server])
      if @server.nil?
        redirect_to(:action => 'show', :server => nil)
        return
      end
      if params[:path]
        @directory = @server.directories.find_by_path(params[:path].to_s)
        if @directory.nil?
          redirect_to :action => 'show', :path => nil
          return
        end      
        @directories_and_sizes = @directory.children.map{|x| [x, x.recursive_size]}
        @files = @directory.files
      else
        @directories_and_sizes = Earth::Directory.roots_for_server(@server).map{|x| [x, x.recursive_size]}
      end
    else
      @servers_and_sizes = Earth::Server.find(:all).map{|x| [x, x.recursive_size]}
    end

    respond_to do |wants|
      wants.html
      wants.xml {render :action => "show.rxml", :layout => false}
      wants.csv do
        @csv_report = StringIO.new
        CSV::Writer.generate(@csv_report, ',') do |csv|
          csv << ['Directory', 'Size (bytes)']
          for directory, size in @directories_and_sizes
            csv << [directory.name, size]
          end
        end
        
        @csv_report.rewind
        send_data(@csv_report.read, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => 'earth_report.csv', :disposition => 'downloaded')
      end
    end
  end
end
