class JobsController < ApplicationController
  def index
    @repositories = current_user.repositories.all
  end

  def new
    @repositories = current_user.repositories.all
    @job = Job.new
  end

  def edit
  end

  def create
    @job = Job.new(params[:job])
    if @job.save
      redirect_to jobs_path
    else
      render "new"
    end
  end

  def update
  end

  def destroy
  end
end
