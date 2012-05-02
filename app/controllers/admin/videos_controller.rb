class Admin::VideosController < AdminController

  def index
    @title = 'Videos'
    @videos, @pagination = Video.paginate(params[:page] ? params[:page].to_i : 1)
    @pagination[:url] = admin_index_url
  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end
end
