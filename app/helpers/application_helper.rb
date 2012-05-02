require 'digest/md5'

module ApplicationHelper

  def gravatar_tag(email, size=50)
    size = size.to_s
    uri = 'https://secure.gravatar.com/avatar/'
    uri += Digest::MD5.hexdigest email.strip.downcase
    uri += '?d=mm&s=' + size
    image_tag uri, :alt => 'Gravatar', :width => size, :height => size
  end
end
