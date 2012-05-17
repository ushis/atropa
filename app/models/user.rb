require 'digest/sha1'

class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation

  has_secure_password

  validates :password, presence: true, on: :create
  validates :login_hash, uniqueness: true, allow_nil: true

  has_many :videos

  def refresh_login_hash!
    self.login_hash = Digest::SHA1.hexdigest Time.now.to_s + self.username
    self.save
  end

  def to_s
    self.username
  end
end
