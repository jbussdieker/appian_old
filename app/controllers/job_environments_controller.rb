class JobEnvironmentsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @job_environment = JobEnvironment.find(params[:id])
  end

  def new
    @job_environment = JobEnvironment.new
  end

  def create
    @job_environment = JobEnvironment.new(params[:job_environment])
    if @job_environment.save
      redirect_to jobs_path
    else
      render "new"
    end
  end

  def update
    @job_environment = JobEnvironment.find(params[:id])
    if @job_environment.update_attributes(params[:job_environment])
      redirect_to jobs_path
    else
      render "edit"
    end
  end

  def destroy
    @job_environment = JobEnvironment.find(params[:id])
    if @job_environment.destroy
      redirect_to jobs_path
    else
      render "edit"
    end
  end

end
