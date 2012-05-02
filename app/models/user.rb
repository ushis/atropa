require 'digest/sha1'

class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation, :login_hash

  has_secure_password

  validates :password, :presence => true, :on => :create

  has_many :videos

  def refresh_login_hash
    self.login_hash = Digest::SHA1.hexdigest Time.now.to_s + self.username
    self.save
  end

  def to_s
    self.username
  end
end
