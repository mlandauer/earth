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
    @server = Earth::Server.find(params[:id])
    @directories_and_sizes = Earth::Directory.roots_for_server(@server).map{|x| [x, x.recursive_size]}
  end
end
