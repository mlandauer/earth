class DirectoriesController < ApplicationController
  def index
    redirect_to :action => :size
  end
  
  def size
    @directory = Directory.find(params[:id])
  end
end
