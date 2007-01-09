require 'csv'

class DirectoriesController < ApplicationController
  def show
    if params[:server] && params[:path]
      server = Earth::Server.find_by_name(params[:server])
      raise "Couldn't find server #{params[:server]}" if server.nil?
      @directory = server.directories.find_by_path(params[:path].to_s)
      raise "Couldn't find directory #{params[:path]}" if @directory.nil?
    else
      @directory = Earth::Directory.find(params[:id])
    end
  
    @directories = @directory.children
    @directories_and_sizes = @directories.map{|x| [x, x.recursive_size]}
    @files = @directory.files
    
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
