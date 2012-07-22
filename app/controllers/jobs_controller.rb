class JobsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @repositories = current_user.repositories.all
  end

  def new
    @repositories = current_user.repositories.all
    @job = Job.new
  end

  def edit
    @repositories = current_user.repositories.all
    @job = Job.find(params[:id])
  end

  def show
    @job = Job.find(params[:id])
    @log = @job.lastlog
  end

  def create
    @repositories = current_user.repositories.all
    @job = Job.new(params[:job])
    if @job.save
      redirect_to jobs_path
    else
      render "new"
    end
  end

  def update
    @repositories = current_user.repositories.all
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      redirect_to jobs_path
    else
      render "edit"
    end
  end

  def build
    @job = Job.find(params[:id])
    @job.build
    redirect_to jobs_path
  end

  def log
    @job = Job.find(params[:id])
    render :text => @job.lastlog
  end

  def destroy
    @repositories = current_user.repositories.all
    @job = Job.find(params[:id])
    if @job.destroy
      redirect_to jobs_path
    else
      render "index"
    end
  end
end
