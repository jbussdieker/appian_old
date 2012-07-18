class Key < ActiveRecord::Base
  attr_accessible :key, :name
  validate :key_is_valid

  belongs_to :user

  after_destroy :write_authorized_keys
  after_save :write_authorized_keys

  def write_authorized_keys
    data = ""
    Key.all.each do |key|
      data << "command=\"#{File.join(Rails.root, "script", "git")} #{user.email}\""
      data << ",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty "
      data << "#{key.key}\n"
    end
    keyfile = File.join(Rails.configuration.sshdir, "authorized_keys")
    File.open(keyfile, 'w') {|f| f.write(data) }
  end

  def key_is_valid
    begin
       Net::SSH::KeyFactory.load_data_public_key(key)
    rescue Exception => e
       errors.add(:key, e.message)
       false
    end
  end
end
