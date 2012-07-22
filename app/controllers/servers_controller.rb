class ServersController < ApplicationController
  def new
    @server = Server.new
  end

  def edit
    @server = Server.find(params[:id])
  end

end
