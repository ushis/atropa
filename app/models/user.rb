require 'digest/sha1'
require 'digest/md5'
require 'openssl'
require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation

  has_secure_password

  validates :password,            presence: true,   on: :create
  validates :username,            uniqueness: true
  validates :email,               uniqueness: true
  validates :login_hash,          uniqueness: true, allow_nil: true
  validates :password_reset_hash, uniqueness: true, allow_nil: true

  has_many :videos

  before_save lambda { update_gravatar_id if email_changed? }

  def self.authenticate_by_reset_hash(hash)
    sql = 'password_reset_hash = ? and password_reset_set_at > ?'
    where(sql, hash, 20.minutes.ago).first
  end

  def update_gravatar_id
    self.gravatar_id = Digest::MD5.hexdigest email.strip.downcase
  end

  def refresh_login_hash
    self.login_hash = unique_hash
  end

  def refresh_login_hash!
    refresh_login_hash
    save
  end

  def refresh_api_key
    self.api_key = unique_hash
  end

  def refresh_api_key!
    refresh_api_key
    save
  end

  def refresh_password_reset_hash
    self.password_reset_hash = unique_hash
    self.password_reset_set_at = Time.now
  end

  def refresh_password_reset_hash!
    refresh_password_reset_hash
    save
  end

  def sign(data)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, api_key, data)
  end

  def verify_signature(data, signature)
    sign(data) == signature
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
