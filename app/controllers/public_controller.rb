class PublicController < ActionController::Base
  protect_from_forgery

  def index
    @videos, @pagination = Video.paginate(params[:page].to_i, includes: [:tags], per_page: 6)
    @pagination[:url] = {action: :index}
    @title = 'videos : page ' + @pagination[:current].to_s
  end

  def tag
    tag = Tag.includes(videos: :tags).order('videos.created_at DESC').find params[:id]
  rescue
    not_found
  else
    not_found if tag.videos.length.zero?

    total = tag.videos.length.fdiv(6).ceil
    page = params[:page].to_i

    if page > total
      page = total
    elsif page < 1
      page = 1
    end

    @videos = tag.videos[(page - 1) * 6, 6]
    @pagination = {total: total, current: page, url: {action: :tag, id: tag, slug: tag.slug}}
    @title = tag.tag
    render :index
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
