require 'digest/sha1'
require 'digest/md5'
require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation

  has_secure_password

  validates :password,   presence: true,   on: :create
  validates :username,   uniqueness: true
  validates :email,      uniqueness: true
  validates :login_hash, uniqueness: true, allow_nil: true

  has_many :videos

  before_save lambda { update_gravatar_id if email_changed? }

  def update_gravatar_id
    self.gravatar_id = Digest::MD5.hexdigest email.strip.downcase
  end

  def refresh_login_hash!
    self.login_hash = unique_hash
    save
  end

  def refresh_api_key!
    self.api_key = unique_hash
    save
  end

  def confirm_signature(data, signature)
    Digest::SHA1.hexdigest(data + self.api_key) == signature
  end

  def to_s
    self.username
  end

  def as_json(options = {})
    json = super(only: [:id, :username])
    json[:videos] = videos if association(:videos).loaded?
    json
  end

  private
  def unique_hash
    Digest::SHA1.hexdigest SecureRandom.uuid
  end
end
