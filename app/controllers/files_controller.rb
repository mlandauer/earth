# Copyright (C) 2007 Rising Sun Pictures and Matthew Landauer
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

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
    @size_value = params[:file][:size].empty? ? "0" : params[:file][:size]

    @files = Earth::File.find(:all, :order => :id, :conditions => ['NAME LIKE ? AND UID LIKE ? AND BYTES >= ?', 
      @filename_value.tr('*', '%'), @user_value, @size_value ])

  end
end
