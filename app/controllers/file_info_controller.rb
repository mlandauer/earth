class FileInfoController < ApplicationController
  layout 'master'

  def index
    find
    render :action => 'find'
  end

  def find
    if request.post?
      @find_value = params[:find_value]
      @file_info = FileInfo.find(:all, :conditions => ["NAME LIKE ?", @find_value.tr('*','%')])
      render :action => 'results'
    end
  end
end
