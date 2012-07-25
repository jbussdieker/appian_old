class BuildsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @job = Job.find(params[:job_id])
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    @builds = Jenkins::Api.job(@job.name, 3)
  end

  def show
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    @job = Job.find(params[:job_id])
    @log = Jenkins::Api.console(@job.name, nil, params[:id])
  end

  def log
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    @job = Job.find(params[:job_id])
    @log = Jenkins::Api.console(@job.name, nil, params[:id])
    render :text => @log
  end
end
