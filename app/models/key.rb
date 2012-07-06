class Key < ActiveRecord::Base
  attr_accessible :key, :name
  validate :key_is_valid

  belongs_to :user

  def key_is_valid
    begin
       Net::SSH::KeyFactory.load_data_public_key(key)
    rescue Exception => e
       errors.add(:key, e.message)
       false
    end
  end
end
