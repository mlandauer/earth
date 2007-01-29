class ServersController < ApplicationController
  # GET /servers
  # GET /servers.xml
  def index
    @servers = Earth::Server.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @servers.to_xml }
    end
  end

  # GET /servers/1
  # GET /servers/1.xml
  def show
    @server = Earth::Server.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @server.to_xml }
    end
  end

  # GET /servers/1;edit
  def edit
    @server = Earth::Server.find(params[:id])
  end

  # PUT /servers/1
  # PUT /servers/1.xml
  def update
    @server = Earth::Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(params[:server])
        flash[:notice] = 'Server was successfully updated.'
        format.html { redirect_to server_url(@server) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @server.errors.to_xml }
      end
    end
  end
end
