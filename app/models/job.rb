class Job < ActiveRecord::Base
  attr_accessible :branch, :job_type_id, :repository_id

  before_create :create_job
  before_destroy :delete_job

  belongs_to :repository

  def user
    repository.user
  end

  def name
    "#{user.name}-#{repository.name}-#{branch}"
  end

  def create_job
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    begin
      result = Jenkins::Api.create_job(name, Jenkins::JobConfigBuilder.new{})
      if result == false
        err = "Create job failed"
      end
    rescue Exception => e
      result = false
      err = e
    end

    if result == false
      errors.add("Build Server:", err)
      return false
    end
  end

  def delete_job
    uri = URI.parse("#{Rails.configuration.buildurl}/job/#{name}/doDelete")
    Net::HTTP.post_form(uri, {})

    # TODO: This part is broken
    #uri = URI::parse(ENV["APPIAN_BUILD_URL"])
    #Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    #Jenkins::Api.delete_job(name)
  end

  def build_info
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    Jenkins::Api.job name
  end
end
