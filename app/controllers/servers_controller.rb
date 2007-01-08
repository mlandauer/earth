class ServersController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @children_and_sizes = Earth::Server.find(:all).map{|x| [x, x.recursive_size]}
    # Sort the directories so that the largest comes first
    @children_and_sizes.sort!{|a,b| b[1] <=> a[1]}
    if @children_and_sizes.empty?
      @max_size = 0
    else
      @max_size = @children_and_sizes.first[1]
    end
    if @max_size == 0
      @max_size = 1
    end
  end
  
  def show
    @server = Earth::Server.find(params[:id])
    @children_and_sizes = Earth::Directory.roots_for_server(@server).map{|x| [x, x.recursive_size]}
    
    # Sort the directories so that the largest comes first
    @children_and_sizes.sort!{|a,b| b[1] <=> a[1]}
    if @children_and_sizes.empty?
      @max_size = 0
    else
      @max_size = @children_and_sizes.first[1]
    end
    if @max_size == 0
      @max_size = 1
    end
  end
end
