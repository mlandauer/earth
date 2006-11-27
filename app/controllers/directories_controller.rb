class DirectoriesController < ApplicationController
  def index
    redirect_to :action => :size
  end
  
  def size
    @directory = Directory.find(params[:id])
    @children_and_sizes = @directory.children.map{|x| [x, x.recursive_size]}
  end
end
