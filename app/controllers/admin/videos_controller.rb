require 'video_url'

class Admin::VideosController < AdminController

  def index
    @title = 'Videos'
    @videos, @pagination = Video.paginate(params[:page] ? params[:page].to_i : 1)
    @pagination[:url] = {:action => :index}
  end

  def create
    begin
      video = Video.new VideoUrl.info(params[:url])
    rescue => e
      flash[:alert] = e.message
      redirect_to request.referer and return
    end

    video.user = current_user
    redirect_to :action => :edit, :id => video and return if video.save
    flash[:alert] = 'Could not safe video.'
    redirect_to request.referer
  end

  def edit
    begin
      @video = Video.includes(:tags, :user).find params[:id]
    rescue
      flash[:alert] = 'Could not find video.'
      redirect_to request.referer and return
    end
  end

  def update

  end

  def destroy
    begin
      video = Video.find params[:id]
    rescue
      flash[:alert] = 'Could not find video.'
      redirect_to request.referer and return
    end

    if video.delete
      flash[:notice] = 'Deleted video.'
    else
      flash[:alert] = 'Could not delete video.'
    end

    redirect_to request.referer
  end
end
