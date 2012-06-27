class Key < ActiveRecord::Base
  attr_accessible :key, :name

  belongs_to :user
end
