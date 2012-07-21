class JobType < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  attr_accessible :name, :script

  after_update :update_jobs
  before_destroy :valid_deps

  default_scope :order => 'name'

  has_many :jobs

  def update_jobs
    jobs.each do |job|
      job.update_job
    end
  end

  def to_s
    name
  end

  def valid_deps
    if jobs.count > 0
      msg = pluralize(jobs.count, "job")
      errors.add("Error", "#{msg} still associated with this type")
      false
    else
      true
    end
  end
end
