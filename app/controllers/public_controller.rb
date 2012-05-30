class PublicController < ActionController::Base
  protect_from_forgery

  before_filter lambda { @tags = Tag.most_popular(32).order(:tag) }

  def index
    @videos = Video.includes(:tags).most_recent(params[:page], 6)
    @title = "videos : page #{params[:page]}"
  end

  def search
    @q = params[:q]
    @videos = Video.includes(:tags).search(@q, params[:page], 6)
    @title = "#{@q} : page #{params[:page]}"
    render :index
  end

  def redirect_search
    if params[:q] && ! params[:q].blank?
      redirect_to action: :search, q: params[:q]
    else
      redirect_to action: :index
    end
  end

  def tag
    @tag = Tag.find params[:id]
  rescue
    not_found and return
  else
    @videos = @tag.most_recent_videos(params[:page], 6).includes(:tags)
    @title = "#@tag : page #{params[:page]}"
    render :index
  end

  def video
    @video = Video.includes(:tags).find params[:id]
  rescue
    not_found and return
  else
    @title = @video.title
  end

  def feed
    @videos = Video.includes(:user, :tags).most_recent(1, 20)

    respond_to do |format|
      format.atom { render layout: false }
      format.json { render :json => @videos }
    end
  end

  def not_found
    @title = '404'
    render :index
  end
end
