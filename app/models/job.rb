class Job < ActiveRecord::Base
  attr_accessible :branch, :job_type_id, :job_environment_id, :repository_id

  after_create :create_job
  before_update :update_job
  before_destroy :delete_job

  belongs_to :repository
  belongs_to :job_type
  belongs_to :job_environment

  default_scope :order => 'branch'

  def user
    repository.user
  end

  def name
    "#{id}-#{user.name}-#{repository.name}"
  end

  def build_cfg
    cfg = Jenkins::JobConfigBuilder.new{}
    cfg.scm = "#{Rails.configuration.gitserver}:#{user.name}/#{repository.name}"
    cfg.scm_branches[0] = branch
    cfg.steps = [
      [:build_shell_step, "#{job_environment.script}\n#{job_type.script}"],
    ]
    cfg
  end

  def lastlog
    begin
      uri = URI::parse(Rails.configuration.buildurl)
      Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
      result = Jenkins::Api.job(name)
      result = Jenkins::Api.get_plain("#{result["lastBuild"]["url"]}/consoleText")
      result.body
    rescue Exception => e
      "ERROR"
    end
  end

  def build
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    result = Jenkins::Api.build_job(name)
    if result == false
      err = "Create job failed"
    end
    
    if result == false
      errors.add("Build Server:", err)
      return false
    end
  end

  def update_job
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    begin
      result = Jenkins::Api.update_job(name, build_cfg)
      if result == false
        err = "Modify job failed"
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

  def create_job
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    begin
      result = Jenkins::Api.create_job(name, build_cfg)
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
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    Jenkins::Api.delete_job(name)
  end

  def build_details(build_number)
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    Jenkins::Api.build_details(name, build_number)
  end

  def build_info
    return @build_info if @build_info
    uri = URI::parse(Rails.configuration.buildurl)
    Jenkins::Api.setup_base_url(:host => uri.host, :port => uri.port)
    begin
      @build_info = Jenkins::Api.job name
    rescue Exception => e
      []
    end
  end
end
