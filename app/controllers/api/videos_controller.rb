class Api::VideosController < ApiController
  def index
    respond_with(Video.includes(:tags, :user).all)
  end

  def show
    respond_with(Video.includes(:user, :tags).find(signed_params[:id]))
  rescue
    respond_with({error: 'Video not found.'}, 404)
  end

  def create
    video = Video.new_from_url signed_params[:url]
  rescue => e
    respond_with({error: e.message}, 600) and return
  else
    video.user = current_user
    video.tags = Tag.from_s(signed_params[:tags]) if signed_params[:tags]

    if video.save
      respond_with(video)
    else
      respond_with({error: 'Could not save video'}, 601)
    end
  end

  def update
    video = Video.includes(:user).find(signed_params[:id])
  rescue
    respond_with({error: 'Video not found'}, 404) and return
  else
    video.tags = Tag.from_s signed_params[:tags] if signed_params[:tags]

    if video.save
      respond_with(video)
    else
      resond({error: 'Could not save video'}, 601)
    end
  end

  def destroy
    video = Video.find(signed_params[:id])
  rescue
    respond_with({error: 'Video not found.'}, 404) and return
  else
    if video.destroy
      respond_with({message: "Deleted video: #{video.title}"})
    else
      respond_with({error: 'Could not delete video.'}, 601)
    end
  end
end
