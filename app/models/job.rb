class Job < ActiveRecord::Base
  attr_accessible :branch, :job_type_id, :repository_id

  belongs_to :repository
end
