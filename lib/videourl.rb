require 'open-uri'

module VideoUrl
  class Error < StandardError
  end

  class InvalidUrlError < Error
    def initialize(url)
      super("Invalid url: #{url}")
    end
  end

  class RequestError < Error
  end

  class InvalidResponseError < Error
  end

  class EmbedNotAllowedError < Error
    def initialize
      super('It is not allowed to embed this video')
    end
  end

  def self.video_info(url)
    self.constants.each do |provider|
      begin
        return self.const_get(provider).info(url)
      rescue InvalidUrlError, NoMethodError
        next
      end
    end

    raise InvalidUrlError, url
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
      raise InvalidUrlError, url
    end

    begin
      ActiveSupport::JSON.decode open(api % {id: matches[1]}).read()
    rescue
      raise RequestError, 'Could not retrieve video info'
    end
  end
end


module VideoUrl::Vimeo
  include VideoUrl

  PATTERN = /\Ahttp(?:s)?:\/\/vimeo\.com\/([0-9]+)\z/
  API = 'https://vimeo.com/api/v2/video/%{id}.json'
  URL = 'https://vimeo.com/%{id}'
  SRC = 'https://player.vimeo.com/video/%{id}?title=0&amp;byline=0&amp;portrait=0'

  def self.info(url)
    data = VideoUrl.request(url, PATTERN, API).fetch(0)

    if data['embed_privacy'] != 'anywhere'
      raise EmbedNotAllowdError
    end

    {
      vid:      data.fetch('id'),
      title:    data.fetch('title'),
      width:    data.fetch('width'),
      height:   data.fetch('height'),
      preview:  data.fetch('thumbnail_large'),
      provider: 'vimeo'
    }
  rescue KeyError
    raise InvalidResponseError, 'Vimeo responded with invalid data'
  end
end


module VideoUrl::Youtube
  include VideoUrl

  PATTERN = /\Ahttp(?:s)?:\/\/(?:www\.)?youtube\.com[^ \n]*(?:[\?&]v=)([^ &\n]+)/
  API = 'https://gdata.youtube.com/feeds/api/videos/%{id}?v=2&alt=json'
  URL = 'https://www.youtube.com/watch?v=%{id}'
  SRC = 'https://www.youtube.com/embed/%{id}?rel=0'

  def self.info(url)
    data = VideoUrl.request(url, PATTERN, API).fetch('entry')

    data.fetch('yt$accessControl').each do |access|
      if access['action'] == 'embed'
        raise EmbedNotAllowdError if access['permission'] != 'allowed'
        break
      end
    end

    {
      vid:      data.fetch('media$group').fetch('yt$videoid').fetch('$t'),
      title:    data.fetch('title').fetch('$t'),
      width:    data.fetch('media$group').fetch('media$thumbnail').fetch(2).fetch('width'),
      height:   data.fetch('media$group').fetch('media$thumbnail').fetch(2).fetch('height'),
      preview:  data.fetch('media$group').fetch('media$thumbnail').fetch(2).fetch('url'),
      provider: 'youtube'
    }
  rescue KeyError
    raise InvalidResponseError, 'Youtube responded with invalid data'
  end
end


module VideoUrl::Dailymotion
  include VideoUrl

  PATTERN = /\Ahttp(?:s)?:\/\/www\.dailymotion\.com\/video\/([^_]+)/
  API = 'https://api.dailymotion.com/video/%{id}?fields=' +
        'id,thumbnail_large_url,title,allow_embed,aspect_ratio'
  URL = 'https://www.dailymotion.com/video/%{id}'
  SRC = 'https://www.dailymotion.com/embed/video/%{id}'

  def self.info(url)
    data = VideoUrl.request(url, PATTERN, API)

    unless data.fetch('allow_embed')
      raise EmbedNotAllowedError
    end

    {
      vid:      data.fetch('id'),
      title:    data.fetch('title'),
      width:    data.fetch('aspect_ratio').to_f * 360,
      height:   360,
      preview:  data.fetch('thumbnail_large_url'),
      provider: 'dailymotion'
    }
  rescue KeyError
    raise InvalidResponseError, 'Dailymotion responded with invalid data'
  end
end
