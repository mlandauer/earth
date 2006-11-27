class DirectoriesController < ApplicationController
  def index
    redirect_to :action => :size
  end
  
  def size
    @directory = Directory.find(params[:id])
    @directory_size = @directory.size
    @children_and_sizes = @directory.children.map{|x| [x, x.recursive_size]}
    @max_size = @children_and_sizes.map{|x| x[1]}.max
    # Include the size of this directory
    if @directory_size > @max_size
      @max_size = @directory_size
    end
  end
end
