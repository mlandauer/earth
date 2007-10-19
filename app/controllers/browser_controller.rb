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

require 'csv'
require 'pp'

class BrowserController < ApplicationController
  before_filter :load_context, :only => [:index,:flat,:show]
  
  def index
    redirect_to :action => 'show'
  end

  def flat


    @show_hidden = params[:show_hidden]

    @any_empty = false
    @any_hidden = true
    
    @page_size = 25
    @current_page = (params[:page] || 1).to_i

    @default_sort_by = [ "size", nil, nil ]
    @max_num_sort_criteria = 3

    @default_order = {
      "name" => "asc",
      "path" => "asc",
      "size" => "desc",
      "modified" => "desc"
    }

    criteria_to_order_map = {
      "name" => "lower(files.name)",
      "path" => "lower(directories.path)",
      "size" => "bytes",
      "modified" => "modified"
    }

    order = nil
    1.upto(@max_num_sort_criteria) do |sort_index|
      criteria_name = params["sort#{sort_index}".to_sym] || @default_sort_by[sort_index - 1]      
      if criteria_name
        direction = params["order#{sort_index}".to_sym] || @default_order[criteria_name]

        # avoid SQL injection
        direction = "asc" if direction != "asc" and direction != "desc"

        if order.nil?
          order = ""
        else
          order += ", "
        end
        order += "#{criteria_to_order_map[criteria_name]} #{direction}"
      end
    end

    joins = "JOIN directories ON files.directory_id = directories.id"
    include_attributes = [ "name", "directory_id", "modified", "bytes", "uid" ]
    select = include_attributes.map {|attr| "files.#{attr} as #{attr}" }.join(", ")

    if @directory
      conditions = [ 
        "directories.server_id = ? " + \
        " AND directories.lft >= ? " + \
        " AND directories.lft <= ?", 
        @server.id, 
        @directory.lft, 
        @directory.rgt 
      ]
    elsif @server
      conditions = [ 
        "directories.server_id = ?", 
        @server.id 
      ]
    else
      conditions = nil
    end

    if not @show_hidden
      if conditions
        conditions[0] = "(not files.name like '.%') and " + conditions[0]
      else
        conditions = "not files.name like '.%'"
      end
    end

    Earth::File.with_filter(params) do
      file_count = Earth::File.count(:joins => joins, 
                                     :conditions => conditions)
      @page_count = (file_count + @page_size - 1) / @page_size
      
      @files = Earth::File.find(:all, 
                                :select => select,
                                :joins => joins,
                                :conditions => conditions,
                                :order => order,
                                :offset => ((@current_page - 1) * @page_size),
                                :limit => @page_size)
    end
  end

  def show
    # Filter parameters
    @show_empty  = params[:show_empty]
    @show_hidden = params[:show_hidden]

    @servers_and_bytes,@directories_and_bytes,@files,@any_empty,@any_hidden = Earth.filter_context(@server,@directory,params)

    respond_to do |wants|
      wants.html
      wants.xml
      wants.csv do
        @csv_report = StringIO.new
        CSV::Writer.generate(@csv_report, ',') do |csv|
          csv << ['Directory', 'Size (bytes)']
          for directory, size in @directories_and_bytes
            csv << [directory.name, size]
          end
        end
        
        @csv_report.rewind
        send_data(@csv_report.read, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => 'earth_report.csv', :disposition => 'downloaded')
      end

      logger.debug("end of controller")
    end
  end
  
  def auto_complete_for_filter_user
    if User.ldap_configured?
      @users = User.find_matching(params[:filter_user])
      render :inline => '<%= content_tag("ul", @users.map { |user| content_tag("li", h(user.name)) })%>'
    end
  end
  
  protected
  def load_context
    @server    = Earth::Server.find_by_name(params[:server])           if params[:server]
    @directory = @server.directories.find_by_path(params[:path] * '/') if @server && params[:path]
  end
end
