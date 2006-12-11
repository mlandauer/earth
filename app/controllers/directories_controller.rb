class DirectoriesController < ApplicationController
  def size
    if params[:server] && params[:path]
      server = Server.find_by_name(params[:server])
      raise "Couldn't find server #{params[:server]}" if server.nil?
      @directory = server.directories.find_by_path(params[:path])
      raise "Couldn't find directory #{params[:path]}" if @directory.nil?
    else
      @directory = Directory.find(params[:id])
    end
    
    @directory_size = @directory.size
    @children_and_sizes = @directory.children.map{|x| [x, x.recursive_size]}
    # Sort the directories so that the largest comes first
    @children_and_sizes.sort!{|a,b| b[1] <=> a[1]}
    if @children_and_sizes.empty?
      @max_size = @directory_size
    else
      @max_size = @children_and_sizes.first[1]
      # Include the size of this directory
      if @directory_size > @max_size
        @max_size = @directory_size
      end
    end
    
    respond_to do |wants|
      wants.html
      wants.xml {render :action => "size.rxml", :layout => false}
    end
  end
  
  def file_sizes
    @directory = Directory.find(params[:id])
  end
  
end
