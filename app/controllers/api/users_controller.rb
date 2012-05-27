class Api::UsersController < ApiController
  def show
    respond_with(User.includes(videos: :tags).find(signed_params[:id]))
  rescue
    respond_with({error: 'User not found'}, 404)
  end
end
