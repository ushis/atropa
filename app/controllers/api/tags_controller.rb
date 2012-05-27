class Api::TagsController < ApiController
  def index
    respond_with(Tag.includes(:videos).all)
  end

  def show
    respond_with(Tag.includes(:videos).find(signed_params[:id]))
  rescue
    respond_with({error: 'Tag not found.'}, 404)
  end

  def update
    tag = Tag.includes(:videos).find(signed_params[:id])
  rescue
    respond_with({error: 'Tag not found.'}, 404)
  else
    tag.tag = signed_params[:tag]

    if tag.save
      respond_with(tag)
    else
      respond_with({error: 'Could not save tag.'}, 601)
    end
  end

  def destroy
    tag = Tag.find(signed_params[:id])
  rescue
    respond_with({error: 'Tag not found.'}, 404) and return
  else
    if tag.destroy
      respond_with({message: "Destroyed tag: #{tag.tag}"})
    else
      respond_with({error: 'Could not destroy tag.'}, 601)
    end
  end
end
