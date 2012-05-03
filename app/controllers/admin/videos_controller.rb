class Admin::VideosController < AdminController

  def index
    @title = 'Videos'
    @videos, @pagination = Video.paginate(params[:page] ? params[:page].to_i : 1)
    @pagination[:url] = {:action => :index}
  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy
    begin
      video = Video.find params[:id]
    rescue
      flash[:alert] = 'Video does not exist.'
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
