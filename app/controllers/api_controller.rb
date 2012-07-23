class ApiController < ApplicationController
  def push_notify
    job_logs = ""

    if params["hook"] == "hooks/post-update"
      user_name, repo_name = params["repo"].split("/")
      branch = params["ref"].split("/").last

      @user = User.where(:name => user_name).first
      @repository = @user.repositories.where(:name => repo_name).first
      @repository.jobs.each do |job|
        if job.branch == branch
          job.build
          job_logs << " * Started #{job.job_type}@#{job.job_environment} for #{@repository} (#{branch})\n"
        end
      end
    end

    render :text => job_logs
  end
end
