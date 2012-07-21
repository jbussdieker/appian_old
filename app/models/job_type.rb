class JobType < ActiveRecord::Base
  attr_accessible :name, :script

  has_many :jobs

  def to_s
    name
  end
end
