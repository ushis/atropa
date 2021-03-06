class Api::UsersController < ApiController
  def show
    respond_with(User.includes(videos: :tags).find(signed_params[:id]))
  end

  def not_found
    respond_with('User not found.', 404)
  end
end
