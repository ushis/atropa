require 'open-uri'

module VideoUrl

  def VideoUrl.info(url)
    video_url = nil

    self.constants.each do |provider|
      begin
        video_url = self.const_get(provider).new(url) and break
      rescue
        next
      end
    end

    raise 'Invalid url' if video_url.nil?
    video_url.info
  end

  def api_url(url, pattern, api)
    raise ArgumentError, 'Invalid uri' if (matches = pattern.match(url)).nil?

    begin
      api.gsub '{id}', matches[1]
    rescue KeyError
      raise ArgumentError, 'Invalid pattern'
    end
  end

  def video_info
    ActiveSupport::JSON.decode open(@api).read()
  rescue
    raise 'Could not retrieve video info'
  end
end

class VideoUrl::VimeoUrl
  include VideoUrl

  PATTERN = /^http(?:s)?:\/\/vimeo\.com\/([0-9]+)$/
  API = 'http://vimeo.com/api/v2/video/{id}.json'

  def initialize(url)
    @api = api_url url, PATTERN, API
  end

  def info
    data = self.video_info[0]

    {vid:      data['id'],
     title:    data['title'],
     width:    data['width'],
     height:   data['height'],
     preview:  data['thumbnail_large'],
     provider: 'vimeo'}
  rescue KeyError
    raise 'Vimeo responded with invalid data'
  end
end

class VideoUrl::YoutubeUrl
  include VideoUrl

  PATTERN = /^http(?:s)?:\/\/(?:www\.)?youtube\.com[^ \n]*(?:[\?&]v=)([^ &\n]+)/
  API = 'https://gdata.youtube.com/feeds/api/videos/{id}?v=2&alt=json'

  def initialize(url)
    @api = api_url url, PATTERN, API
  end

  def info
    data = self.video_info['entry']

    {vid:      data['media$group']['yt$videoid']['$t'],
     title:    data['title']['$t'],
     width:    data['media$group']['media$thumbnail'][2]['width'],
     height:   data['media$group']['media$thumbnail'][2]['height'],
     preview:  data['media$group']['media$thumbnail'][2]['url'],
     provider: 'youtube'}
  rescue KeyError
    raise 'Youtube responded with invalid data'
  end
end
