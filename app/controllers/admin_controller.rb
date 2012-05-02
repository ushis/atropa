class AdminController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate

  helper_method :current_user

  def authenticate
    redirect_to admin_login_url unless current_user
  end

  private
  def current_user
    @current_user ||= User.find_by_login_hash(session[:login_hash]) if session[:login_hash]
  end
end
