require 'video_url'

class Api::VideosController < ApiController
  def index
    videos = Video.includes(:tags, :user).where(id: current_user).all
    respond(videos.collect { |video| video.api_friendly })
  end

  def show
    video = Video.find(signed_params[:id])
  rescue
    respond({error: 'Video not found.'}, 404) and return
  else
    respond(video.api_friendly)
  end

  def create
    video = Video.new VideoUrl.info(signed_params[:url])
  rescue => e
    respond({error: e.message}, 600) and return
  else
    video.user = current_user
    video.tags = Tag.from_s(signed_params[:tags]) if signed_params[:tags]

    if video.save
      respond(video.api_friendly)
    else
      respond({error: 'Could not save video'}, 601)
    end
  end

  def update
    video = Video.find(signed_params[:id])
  rescue
    respond({error: 'Video not found'}, 404) and return
  else
    video.tags = Tag.from_s signed_params[:tags] if signed_params[:tags]

    if video.save
      respond(video.api_friendly)
    else
      resond({error: 'Could not save video'}, 601)
    end
  end

  def destroy
    video = Video.find(signed_params[:id])
  rescue
    respond({error: 'Video not found.'}, 404) and return
  else
    if video.destroy
      respond({message: "Deleted video: #{video.title}"})
    else
      respond({error: 'Could not delete video.'}, 601)
    end
  end
end
