class Public::GraphsController < PublicController
  before_filter lambda { @title = "graph : #{params[:action]}" }

  def index
    @title = 'graphs'
  end

  def fishnet
    respond_to do |format|
      format.html { render :graph }
      format.json { render json: Video.connections }
    end
  end

  def tagmap
    respond_to do |format|
      format.html { render :graph }
      format.json { render json: Tag.with_popularity }
    end
  end

  def fountain
    respond_to do |format|
      format.html { render :graph }
      format.json { render json: Video.connections }
    end
  end
end
