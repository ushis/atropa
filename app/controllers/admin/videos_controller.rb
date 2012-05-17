require 'video_url'

class Admin::VideosController < AdminController

  before_filter lambda { @body_class = 'form' }, only: [:edit, :update]

  def index
    @title = 'Videos'
    @videos, @pagination = Video.paginate(params[:page].to_i, includes: [:tags, :user])
    @pagination[:url] = {action: :index}
  end

  def create
    video = Video.new VideoUrl.info(params[:url])
  rescue => e
    flash[:alert] = e.message
    go_back and return
  else
    video.user = current_user
    redirect_to(action: :edit, id: video) and return if video.save
    flash[:alert] = 'Could not safe video.'
    go_back
  end

  def edit
    return unless @video = find_or_go_back(params[:id])
    @title = @video.title
    @tags = Tag.order(:tag).pluck(:tag)
  end

  def update
    return unless @video = find_or_go_back(params[:id])
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
    return unless video = find_or_go_back(params[:id])

    if video.delete
      flash[:notice] = 'Deleted video.'
    else
      flash[:alert] = 'Could not delete video.'
    end

    go_back
  end

  private
  def find_or_go_back(id)
    Video.includes(:tags, :user).find(id)
  rescue
    flash[:alert] = 'Could not find video.'
    go_back and return
  end
end
