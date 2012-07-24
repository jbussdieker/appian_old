class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :access_key_id, :secret_access_key
  # attr_accessible :title, :body

  has_many :user_tokens
  has_many :keys
  has_many :repositories

  validates_uniqueness_of :name
  validates_presence_of :name
  validate :name_format

  def name_format
    all_valid_characters = name =~ /^[a-zA-Z0-9_\-]+$/
    errors.add(:name, "must contain only letters, digits, dashes, or underscores") unless all_valid_characters
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session[:omniauth]
        user.user_tokens.build(:provider => data['provider'], :uid => data['uid'])
      end
    end
  end

  def apply_omniauth(omniauth)
    user_tokens.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (user_tokens.empty? || !password.blank?) && super  
  end

  def to_s
    name
  end
end
