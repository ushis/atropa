class Api::VideosController < ApiController
  def index
    respond_with(Video.includes(:tags, :user))
  end

  def show
    respond_with(Video.includes(:user, :tags).find(signed_params[:id]))
  end

  def create
    video = Video.new_from_url signed_params[:url]
  rescue => e
    respond_with(e.message, 600) and return
  else
    video.user = current_user
    video.tags = Tag.from_s(signed_params[:tags]) if signed_params[:tags]

    if video.save
      respond_with(video)
    else
      respond_with('Could not save video', 601)
    end
  end

  def update
    video = Video.includes(:user).find(signed_params[:id])
    video.tags = Tag.from_s signed_params[:tags] if signed_params[:tags]

    if video.save
      respond_with(video)
    else
      respond_with('Could not save video', 601)
    end
  end

  def destroy
    video = Video.find(signed_params[:id])

    if video.destroy
      respond_with("Destroyed video: #{video.title}")
    else
      respond_with('Could not delete video.', 601)
    end
  end

  def not_found
    respond_with('Video not found.', 404)
  end
end
