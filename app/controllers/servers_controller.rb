class ServersController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @servers_and_sizes = Earth::Server.find(:all).map{|x| [x, x.recursive_size]}
  end
  
  def show
    if params[:server]
      @server = Earth::Server.find_by_name(params[:server])
    else
      @server = Earth::Server.find(params[:id])
    end
    raise "Couldn't find server #{params[:server]}" if @server.nil?
    @directories_and_sizes = Earth::Directory.roots_for_server(@server).map{|x| [x, x.recursive_size]}
  end
end
