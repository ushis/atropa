module VideoHelper

  URLS = {'vimeo'   => 'http://vimeo.com/{id}',
          'youtube' => 'https://www.youtube.com/watch?v={id}'}

  SOURCES = {'vimeo'   => 'http://player.vimeo.com/video/{id}?title=0&amp;byline=0&amp;portrait=0',
             'youtube' => 'http://www.youtube.com/embed/{id}?rel=0'}

  def video_link(video, txt = nil)
    begin
      url = URLS[video.provider].gsub '{id}', video.vid
    rescue KeyError
      raise ArgumentError, 'Unknown provider'
    end

    link_to txt.nil? ? url : txt, url
  end

  def video_iframe(video, width = 0, height = 0)
    begin
      src = SOURCES[video.provider].gsub('{id}', video.vid)
    rescue KeyError
      raise ArgumentError, 'Unknown provider'
    end

    if width < 1 && height < 1
      width, height = video.width, video.height
    elsif width > 0 && height < 1
      height = (width * video.height) / video.width
    elsif width < 1 && height > 0
      width = (height * video.width) / video.height
    end

    content_tag 'iframe', nil, src: src, frameborder: 0, width: width, height: height
  end
end
