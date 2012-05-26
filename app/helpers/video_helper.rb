module VideoHelper

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
    width, height = video_scale video, width, height
    content_tag 'iframe', nil, src: video.source, frameborder: 0, width: width, height: height
  end

  def video_preview(video, width = 0, height = 0)
    width, height = video_scale video, width, height
    image_tag video.preview, alt: video.title, width: width, height: height
  end
end
