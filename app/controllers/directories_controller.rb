class DirectoriesController < ApplicationController
  def size
    #if params[:server] && params[:path]
    #  @directory = Directory.find_by_server_name_and_path(params[:server], params[:path])
    #else
      @directory = Directory.find(params[:id])
    #end
    
    @directory_size = @directory.size
    @children_and_sizes = @directory.children.map{|x| [x, x.recursive_size]}
    # Sort the directories so that the largest comes first
    @children_and_sizes.sort!{|a,b| b[1] <=> a[1]}
    @max_size = @children_and_sizes.first[1]
    # Include the size of this directory
    if @directory_size > @max_size
      @max_size = @directory_size
    end
  end
end
