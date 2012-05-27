class Api::VideosController < ApiController
  def index
    videos = Video.includes(:tags, :user).where(user_id: current_user).all
    respond(videos)
  end

  def show
    video = Video.includes(:user, :tags).find(signed_params[:id])
  rescue
    respond({error: 'Video not found.'}, 404) and return
  else
    respond(video)
  end

  def create
    video = Video.new_from_url signed_params[:url]
  rescue => e
    respond({error: e.message}, 600) and return
  else
    video.user = current_user
    video.tags = Tag.from_s(signed_params[:tags]) if signed_params[:tags]

    if video.save
      respond(video)
    else
      respond({error: 'Could not save video'}, 601)
    end
  end

  def update
    video = Video.includes(:user).find(signed_params[:id])
  rescue
    respond({error: 'Video not found'}, 404) and return
  else
    video.tags = Tag.from_s signed_params[:tags] if signed_params[:tags]

    if video.save
      respond(video)
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
