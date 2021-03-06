class Api::TagsController < ApiController
  def index
    respond_with(Tag.includes(:videos).all)
  end

  def show
    respond_with(Tag.includes(:videos).find(signed_params[:id]))
  end

  def update
    tag = Tag.includes(:videos).find(signed_params[:id])
    tag.tag = signed_params[:tag]

    if tag.save
      respond_with(tag)
    else
      respond_with('Could not save tag.', 601)
    end
  end

  def destroy
    tag = Tag.find(signed_params[:id])

    if tag.destroy
      respond_with("Destroyed tag: #{tag.tag}")
    else
      respond_with('Could not destroy tag.', 601)
    end
  end

  def not_found
    respond_with('Tag not found.', 404)
  end
end
