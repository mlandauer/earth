require 'csv'

class DirectoriesController < ApplicationController
  def show
    if params[:path]
      server_name = params[:path][0]
      path_name = '/' + params[:path][1..-1].join('/')
      server = Earth::Server.find_by_name(server_name)
      raise "Couldn't find server #{server_name}" if server.nil?
      @directory = server.directories.find_by_path(path_name)
      raise "Couldn't find directory #{path_name}" if @directory.nil?
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
