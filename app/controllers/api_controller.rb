class ApiController < ApplicationController
  def index
    render :text => "TESTING 1,2,3"
  end

  def push_notify
    render :text => "PARAMS: #{params.except("controller", "action")}\n"
  end
end
