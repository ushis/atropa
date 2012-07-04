class Admin::LoginController < AdminController
  layout 'aether'

  skip_before_filter :authenticate, only: [:form, :login]
  before_filter :forward, only: [:form, :login]

  before_filter lambda { @title = 'Log In' }

  def forward
    redirect_to(admin_url) if current_user
  end

  def form
  end

  def login
    @username = params[:username]
    user = User.find_by_username(@username)

    unless user && user.authenticate(params[:password])
      flash.now[:alert] = 'Wrong username/password combo.'
      render :form and return
    end

    unless user.refresh_login_hash!
      flash.now[:alert] = 'Something went wrong. Let\'s try it again.'
      render :form and return
    end

    if params[:remember_me]
      cookies.signed[:remember_me] = {
        value: user.login_hash,
        expires: 2.weeks.from_now
      }
    end

    session[:login_hash] = user.login_hash
    redirect_to admin_url
  end

  def logout
    @username = current_user.username
    session[:login_hash] = nil
    cookies.delete :remember_me
    render :form
  end
end
