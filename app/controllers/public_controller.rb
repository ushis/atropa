class PublicController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protect_from_forgery

  before_filter :load_tags, except: [:redirect_search, :feed]

  def index
    @videos = Video.includes(:tags).most_recent(params[:page], 6)
    @title = "videos : page #{@videos.current_page}"
  end

  def search
    @q = params[:q]
    @videos = Video.includes(:tags).search(@q, params[:page], 6)
    @title = "#@q : page #{@videos.current_page}"
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
    @videos = @tag.most_recent_videos(params[:page], 6).includes(:tags)
    @title = "#{@tag.tag} : page #{@videos.current_page}"
    render :index
  end

  def video
    @video = Video.includes(:tags).find params[:id]
    @title = @video.title
  end

  def feed
    @videos = Video.includes(:user, :tags).most_recent(1, 20)

    respond_to do |format|
      format.atom { render layout: false }
      format.json { render json: @videos }
    end
  end

  def load_tags
    @tags = Tag.most_popular(32).order(:tag)
  end

  def not_found
    @title = '404'
    render :index
  end
end
