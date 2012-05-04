require 'video_url'

class Admin::VideosController < AdminController

  def index
    @title = 'Videos'
    @videos, @pagination = Video.paginate(params[:page] ? params[:page].to_i : 1)
    @pagination[:url] = {action: :index}
  end

  def create
    video = Video.new VideoUrl.info(params[:url])
  rescue => e
    flash[:alert] = e.message
    redirect_to(request.referer) and return
  else
    video.user = current_user
    redirect_to(action: :edit, id: video) and return if video.save
    flash[:alert] = 'Could not safe video.'
    redirect_to(request.referer)
  end

  def edit
    @video = Video.includes(:tags, :user).find params[:id]
  rescue
    flash[:alert] = 'Could not find video.'
    redirect_to(request.referer) and return
  else
    @title = @video.title
    @bodyclass = 'form'
    @tags = Tag.all_as_a
  end

  def update

  end

  def destroy
    video = Video.find params[:id]
  rescue
    flash[:alert] = 'Could not find video.'
    redirect_to(request.referer) and return
  else
    if video.delete
      flash[:notice] = 'Deleted video.'
    else
      flash[:alert] = 'Could not delete video.'
    end

    redirect_to(request.referer)
  end
end
