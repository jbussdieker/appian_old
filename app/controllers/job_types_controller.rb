class JobTypesController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @job_type = JobType.find(params[:id])
  end

  def new
    @job_type = JobType.new
  end

  def create
    @job_type = JobType.new(params[:job_type])
    if @job_type.save
      redirect_to jobs_path
    else
      render "new"
    end
  end

  def update
    @job_type = JobType.find(params[:id])
    if @job_type.update_attributes(params[:job_type])
      redirect_to jobs_path
    else
      render "edit"
    end
  end

  def destroy
    @job_type = JobType.find(params[:id])
    if @job_type.destroy
      redirect_to jobs_path
    else
      render "edit"
    end
  end

end
