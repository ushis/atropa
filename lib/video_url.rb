require 'open-uri'

module VideoUrl

  def self.info(url)
    self.constants.each do |provider|
      begin
        return self.const_get(provider).info(url)
      rescue
        next
      end
    end

    raise 'Invalid url'
  end

  def self.request(url, pattern, api)
    raise 'Invalid url' if (matches = pattern.match(url)).nil?

    begin
      ActiveSupport::JSON.decode open(api.gsub('{id}', matches[1])).read()
    rescue
      raise 'Could not retrieve video info'
    end
  end
end


class VideoUrl::VimeoUrl

  PATTERN = /\Ahttp(?:s)?:\/\/vimeo\.com\/([0-9]+)\z/
  API = 'http://vimeo.com/api/v2/video/{id}.json'

  def self.info(url)
    data = VideoUrl.request(url, PATTERN, API)[0]

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

  PATTERN = /\Ahttp(?:s)?:\/\/(?:www\.)?youtube\.com[^ \n]*(?:[\?&]v=)([^ &\n]+)/
  API = 'https://gdata.youtube.com/feeds/api/videos/{id}?v=2&alt=json'

  def self.info(url)
    data = VideoUrl.request(url, PATTERN, API)['entry']

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
