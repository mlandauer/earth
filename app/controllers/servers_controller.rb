class ServersController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @server_pages, @servers = paginate :servers, :per_page => 10
  end

  def show
    @server = Server.find(params[:id])
  end

  def new
    @server = Server.new
  end

  def create
    @server = Server.new(params[:server])
    if @server.save
      flash[:notice] = 'Server was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @server = Server.find(params[:id])
  end

  def update
    @server = Server.find(params[:id])
    if @server.update_attributes(params[:server])
      flash[:notice] = 'Server was successfully updated.'
      redirect_to :action => 'show', :id => @server
    else
      render :action => 'edit'
    end
  end

  def destroy
    Server.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
