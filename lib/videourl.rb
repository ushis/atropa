require 'open-uri'

module VideoUrl
  class Error < StandardError
  end

  class InvalidUrlError < Error
  end

  class RequestError < Error
  end

  class InvalidResponseError < Error
  end

  def self.video_info(url)
    self.constants.each do |provider|
      begin
        return self.const_get(provider).info(url)
      rescue InvalidUrlError, NoMethodError
        next
      end
    end

    raise InvalidUrlError, "Invalid url: #{url}"
  end

  def self.video_url(provider, id)
    self.provider_from_s(provider)::URL % {id: id}
  end

  def self.video_src(provider, id)
    self.provider_from_s(provider)::SRC % {id: id}
  end

  def self.provider_from_s(provider)
    self.const_get(provider.camelize)
  rescue NameError
    raise ArgumentError, 'Unknown provider'
  end

  def self.request(url, pattern, api)
    if (matches = pattern.match(url)).nil?
      raise InvalidUrlError, 'Invalid url'
    end

    begin
      ActiveSupport::JSON.decode open(api % {id: matches[1]}).read()
    rescue
      raise RequestError, 'Could not retrieve video info'
    end
  end
end


module VideoUrl::Vimeo

  PATTERN = /\Ahttp(?:s)?:\/\/vimeo\.com\/([0-9]+)\z/
  API = 'https://vimeo.com/api/v2/video/%{id}.json'
  URL = 'https://vimeo.com/%{id}'
  SRC = 'https://player.vimeo.com/video/%{id}?title=0&amp;byline=0&amp;portrait=0'

  def self.info(url)
    data = VideoUrl.request(url, PATTERN, API)[0]

    {vid:      data['id'],
     title:    data['title'],
     width:    data['width'],
     height:   data['height'],
     preview:  data['thumbnail_large'],
     provider: 'vimeo'}
  rescue KeyError
    raise InvalidResponseError, 'Vimeo responded with invalid data'
  end
end


module VideoUrl::Youtube

  PATTERN = /\Ahttp(?:s)?:\/\/(?:www\.)?youtube\.com[^ \n]*(?:[\?&]v=)([^ &\n]+)/
  API = 'https://gdata.youtube.com/feeds/api/videos/%{id}?v=2&alt=json'
  URL = 'https://www.youtube.com/watch?v=%{id}'
  SRC = 'https://www.youtube.com/embed/%{id}?rel=0'

  def self.info(url)
    data = VideoUrl.request(url, PATTERN, API)['entry']

    {vid:      data['media$group']['yt$videoid']['$t'],
     title:    data['title']['$t'],
     width:    data['media$group']['media$thumbnail'][2]['width'],
     height:   data['media$group']['media$thumbnail'][2]['height'],
     preview:  data['media$group']['media$thumbnail'][2]['url'],
     provider: 'youtube'}
  rescue KeyError
    raise InvalidResponseError, 'Youtube responded with invalid data'
  end
end
