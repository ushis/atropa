class ApiController < ActionController::Base
  respond_to :json

  before_filter :authenticate

  def respond_with(obj, status = 200)
    super(obj, status: status, callback: params[:callback], location: nil)
  end

  def authenticate
    signature = params[:signature].to_s
    path = request.fullpath.sub(/(?:\?|&)signature=#{signature}/, '')

    unless current_user.try { |user| user.confirm_signature(path, signature) }
      respond_with('Invalid username or signature', 401)
    end
  end

  private
  def signed_params
    @signed_params ||= request.query_parameters.update(request.path_parameters)
  end

  def current_user
    @current_user ||= User.find_by_username(params[:username]) if params[:username]
  end
end
