require 'csv'

class DirectoriesController < ApplicationController
  def size
    Earth::Directory.transaction do
      if params[:server] && params[:path]
        server = Earth::Server.find_by_name(params[:server])
        raise "Couldn't find server #{params[:server]}" if server.nil?
        @directory = server.directories.find_by_path(params[:path])
        raise "Couldn't find directory #{params[:path]}" if @directory.nil?
      else
        @directory = Earth::Directory.find(params[:id])
      end
    
      @directory_size = @directory.size
      @children_and_sizes = @directory.children.map{|x| [x, x.recursive_size]}
    end
    
    # Sort the directories so that the largest comes first
    @children_and_sizes.sort!{|a,b| b[1] <=> a[1]}
    if @children_and_sizes.empty?
      @max_size = 0
    else
      @max_size = @children_and_sizes.first[1]
    end
    if @max_size == 0
      @max_size = 1
    end
    
    respond_to do |wants|
      wants.html
      wants.xml {render :action => "size.rxml", :layout => false}
      wants.csv do
        @csv_report = StringIO.new
        CSV::Writer.generate(@csv_report, ',') do |csv|
          csv << ['Directory', 'Size (bytes)']
          for directory, size in @children_and_sizes
            csv << [directory.name, size]
          end
        end
        
        @csv_report.rewind
        send_data(@csv_report.read, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => 'earth_report.csv', :disposition => 'downloaded')
      end
    end
  end
end
