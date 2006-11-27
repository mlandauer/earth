class DirectoryInfoController < ApplicationController
  def index
    redirect_to :action => :size
  end
  
  def size
    # If no id is given will find all the directories without parents (the root ones)
    if params[:id]
      @this_directory = DirectoryInfo.find(params[:id])
    end
    @directories = DirectoryInfo.find_all_by_parent_id(params[:id])
  end
end
