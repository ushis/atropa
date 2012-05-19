class PublicController < ActionController::Base
  protect_from_forgery

  before_filter lambda { load_tags unless request.xhr? }

  def index
    @videos, @pagination = paginate_videos
    @pagination[:url] = {action: :index}
    @title = 'videos : page ' + @pagination[:current].to_s
  end

  def search
    redirect_to action: :index if ! params[:q] || params[:q].blank?
    @q = params[:q]
    @videos, @pagination = paginate_videos({conditions: {'videos.title like ?' => '%' + @q + '%'}})
    @pagination[:url] = {action: :search}
    @title = @q + ' : page ' + @pagination[:current].to_s
    render :index
  end

  def redirect_search
    if params[:q] && !params[:q].blank?
      redirect_to action: :search, q: params[:q]
    else
      redirect_to action: :index
    end
  end

  def tag
    @tag = Tag.includes(videos: :tags).order('videos.created_at DESC').find params[:id]
  rescue
    not_found
  else
    total = @tag.videos.length.fdiv(6).ceil
    page = params[:page].to_i

    if page > total
      page = total
    elsif page < 1
      page = 1
    end

    @videos = @tag.videos[(page - 1) * 6, 6]
    @pagination = {total: total, current: page, url: {action: :tag, id: @tag, slug: @tag.slug}}
    @title = @tag.tag + ' : page ' + page.to_s
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

  private
  def paginate_videos(opts = {})
    options = {includes: [:tags], per_page: 6}
    options.update(opts)
    Video.paginate(params[:page].to_i, options)
  end

  def load_tags
    @tags = Tag.order(:tag).all
  end

  def not_found
    raise ActionController::RoutingError.new('404')
  end
end
