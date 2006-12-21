class FilesController < ApplicationController
  def index
    find
    render :action => 'find'
  end

  def find
    if request.post?
      if params[:filename] != ""
        @filename_value = params[:filename]
      else
        @filename_value = "%"
      end
      if params[:user] != ""
        @user_value = params[:user]
      else
        @user_value = "%"
      end
      if params[:size] != ""
        @size_value = params[:size]
      else
        @size_value = "%"
      end            
      @files = Earth::File.find(:all, 
      :conditions => ['NAME LIKE ? AND UID LIKE ? AND SIZE >= ?', @filename_value.tr('*', '%'), @user_value, 
      @size_value ])
      render :action => 'results'
    end
  end
end
