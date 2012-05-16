class PublicController < ActionController::Base
  protect_from_forgery

  def index
    @videos, @pagination = Video.paginate(params[:page] ? params[:page].to_i : 1, 6)
    @pagination[:url] = {action: :index}
    @title = 'videos : page ' + @pagination[:current].to_s
  end

  def tag

  end

  def video
    video = Video.includes(:tags).find params[:id]
  rescue
    not_found
  else
    @title = video.title
    @videos = [video]
    render :index
  end

  def not_found
    raise ActionController::RoutingError.new('404')
  end
end
