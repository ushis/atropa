module VideoHelper

  URLS = {'vimeo'   => 'http://vimeo.com/{id}',
          'youtube' => 'https://www.youtube.com/watch?v={id}'}

  SOURCES = {'vimeo'   => 'http://player.vimeo.com/video/{id}?title=0&amp;byline=0&amp;portrait=0',
             'youtube' => 'http://www.youtube.com/embed/{id}?rel=0'}

  def video_link(video, txt = nil)
    url = URLS[video.provider].gsub '{id}', video.vid
  rescue KeyError
    raise ArgumentError, 'Unknown provider'
  else
    link_to txt.nil? ? url : txt, url
  end

  def video_iframe_src(video)
    SOURCES[video.provider].gsub('{id}', video.vid)
  rescue KeyError
    raise ArgumentError, 'Unknown provider'
  end

  def video_scale(video, width = 0, height = 0)
    if width < 1 && height < 1
      [video.width, video.height]
    elsif width > 0 && height < 1
      [width, (width * video.height) / video.width]
    elsif width < 1 && height > 0
      [(height * video.width) / video.height, height]
    else
      [width, height]
    end
  end

  def video_iframe(video, width = 0, height = 0)
    src = video_iframe_src video
    width, height = video_scale video, width, height
    content_tag 'iframe', nil, src: src, frameborder: 0, width: width, height: height
  end

  def video_preview(video, width = 0, height = 0)
    width, height = video_scale video, width, height
    image_tag video.preview, alt: video.title, width: width, height: height
  end
end
