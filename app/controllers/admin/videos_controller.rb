class Admin::VideosController < AdminController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_filter lambda { @body_class = 'form' }, only: [:edit, :update]

  def index
    @title = 'Videos'
    @videos = Video.includes(:tags, :user).most_recent(params[:page], 20)
  end

  def create
    video = Video.new_from_url(params[:url])
  rescue => e
    flash[:alert] = e.message
    go_back and return
  else
    video.user = current_user

    if video.save
      redirect_to(action: :edit, id: video)
    else
      flash[:alert] = 'Could not safe video.'
      go_back
    end
  end

  def edit
    @video = Video.includes(:tags, :user).find(params[:id])
    @title = @video.title
    @tags = Tag.order(:tag).pluck(:tag)
  end

  def update
    @video = Video.includes(:tags, :user).find(params[:id])
    @video.tags = Tag.from_s(params[:tags]) if params[:tags]

    if @video.save
      flash.now[:notice] = 'Saved changes.'
    else
      flash.now[:alert] = 'Could not save changes.'
    end

    @title = @video.title
    @tags = Tag.order(:tag).pluck(:tag)
    render :edit
  end

  def destroy
    video = Video.find(params[:id])

    if video.destroy
      flash[:notice] = 'Deleted video.'
    else
      flash[:alert] = 'Could not delete video.'
    end

    go_back
  end

  def not_found
    flash[:alert] = 'Could not find video.'
    go_back
  end
end
