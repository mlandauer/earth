class FileInfoController < ApplicationController
  def index
    find
    render :action => 'find'
  end

  def find
  end

  def results
     @find_value = params[:find_value]
     @file_info = FileInfo.find(:all, :conditions => ["NAME LIKE ?", @find_value.tr('*','%')])
  end
end
