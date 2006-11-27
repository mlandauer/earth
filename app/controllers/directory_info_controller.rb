class DirectoryInfoController < ApplicationController
  def index
    redirect_to :action => :size
  end
  
  def size
    if params[:id]
      @directory = DirectoryInfo.find(params[:id])
    end
  end
end
