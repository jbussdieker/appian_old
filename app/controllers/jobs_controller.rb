class JobsController < ApplicationController
  def index
    @repositories = current_user.repositories.all
  end

  def new
    @repositories = current_user.repositories.all
    @job = Job.new
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

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path
  end
end
