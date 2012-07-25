class ServersController < ApplicationController
  before_filter :authenticate_user!

  def index
    begin
      ec2 = AWS::EC2.new(
        :access_key_id => current_user.access_key_id,
        :secret_access_key => current_user.secret_access_key)

      @region = params[:region] || "us-west-1"
      @regions = ec2.regions
      @servers = @regions[@region].instances
    rescue Exception => e
      if e.is_a? AWS::Errors::MissingCredentialsError
        flash[:alert] = "Missing AWS Credentials"
      else
        flash[:alert] = "Invalid AWS Credentials"
      end
      redirect_to edit_user_registration_path(current_user)
    end
  end

  def new
    @server = Server.new
  end

  def edit
    @server = Server.find(params[:id])
  end

end
