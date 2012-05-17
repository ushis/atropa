require 'video_url'

class Admin::VideosController < AdminController

  def index
    @title = 'Videos'
    @videos, @pagination = Video.paginate(params[:page].to_i, includes: [:tags, :user])
    @pagination[:url] = {action: :index}
  end

  def create
    video = Video.new VideoUrl.info(params[:url])
  rescue => e
    flash[:alert] = e.message
    redirect_to :back and return
  else
    video.user = current_user
    redirect_to(action: :edit, id: video) and return if video.save
    flash[:alert] = 'Could not safe video.'
    redirect_to :back
  end

  def edit
    @video = Video.includes(:tags, :user).find params[:id]
  rescue
    flash[:alert] = 'Could not find video.'
    redirect_to :back and return
  else
    @title = @video.title
    @bodyclass = 'form'
    @tags = Tag.order(:tag).pluck(:tag)
  end

  def update
    @video = Video.find params[:id]
  rescue
     flash[:alert] = 'Could not find video'
     redirect_to :back and return
  else
    @video.tags = Tag.from_s(params[:tags]) if params[:tags]

    if @video.save
      flash.now[:notice] = 'Saved changes.'
    else
      flash.now[:alert] = 'Could not save changes.'
    end

    @title = @video.title
    @bodyclass = 'form'
    @tags = Tag.order(:tag).pluck(:tag)
    render :edit
  end

  def destroy
    video = Video.find params[:id]
  rescue
    flash[:alert] = 'Could not find video.'
    redirect_to :back and return
  else
    if video.delete
      flash[:notice] = 'Deleted video.'
    else
      flash[:alert] = 'Could not delete video.'
    end

    redirect_to :back
  end
end
