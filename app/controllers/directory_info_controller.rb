class DirectoryInfoController < ApplicationController
  def index
    redirect_to :action => :size
  end
  
  def size
    @directory = DirectoryInfo.find(params[:id])
  end
end
