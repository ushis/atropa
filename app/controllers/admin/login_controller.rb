class Admin::LoginController < AdminController
  layout 'aether'

  before_filter :forward, :only => [:form, :login]
  skip_before_filter :authenticate, :only => [:form, :login]

  def forward
    redirect_to admin_url if current_user
  end

  def form
    @title = 'Log In'
  end

  def login
    @title = 'Log In'
    @username = params[:username]
    user = User.find_by_username @username

    if user.nil? || ! user.authenticate(params[:password])
      flash[:alert] = 'Wrong username/password combo.'
      render :form and return
    end

    unless user.refresh_login_hash
      flash[:alert] = 'Something went wrong. Let\'s try it again.'
      render :form and return
    end

    session[:login_hash] = user.login_hash
    redirect_to admin_url
  end

  def logout
    @title = 'Log In'
    @username = current_user.username
    session[:login_hash] = nil
    render :form
  end
end
