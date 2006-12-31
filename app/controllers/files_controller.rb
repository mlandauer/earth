class FilesController < ApplicationController
  def index
    find
    render :action => 'find'
  end

  def find
  end
  
  def results
    @filename_value = params[:file][:filename].empty? ? "%" : params[:file][:filename]
    @user_value = params[:file][:user].empty? ? "%" : params[:file][:user]
    @size_value = params[:file][:size].empty? ? "%" : params[:file][:size]

    @files = Earth::File.find(:all, :order => :id, :conditions => ['NAME LIKE ? AND UID LIKE ? AND SIZE >= ?', 
      @filename_value.tr('*', '%'), @user_value, @size_value ])

  end
end
