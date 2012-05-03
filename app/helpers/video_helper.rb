module VideoHelper

  URLS = {'vimeo'   => 'http://vimeo.com/{id}',
          'youtube' => 'https://www.youtube.com/watch?v={id}'}

  def video_link(video, txt = nil)
    begin
      url = URLS[video.provider].gsub '{id}', video.vid
    rescue KeyError
      raise ArgumentError, 'Unknown provider'
    end

    link_to txt.nil? ? url : txt, url
  end
end
