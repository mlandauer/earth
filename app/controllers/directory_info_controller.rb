class DirectoryInfoController < ApplicationController
  def index
    redirect_to :action => :size
    #size
    #render :action => :size
  end
  
  def size
    # If no id is given will find all the directories without parents (the root ones)
    @directories = DirectoryInfo.find_all_by_parent_id(params[:id])
  end
end
