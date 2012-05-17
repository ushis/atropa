class Admin::LoginController < AdminController
  layout 'aether'

  before_filter lambda { @title = 'Log In' }
  before_filter :forward, only: [:form, :login]
  skip_before_filter :authenticate, only: [:form, :login]

  def forward
    redirect_to(admin_url) if current_user
  end

  def form
  end

  def login
    @username = params[:username]

    if ! user = User.find_by_username(@username).try(:authenticate, params[:password])
      flash.now[:alert] = 'Wrong username/password combo.'
    elsif ! user.refresh_login_hash!
      flash.now[:alert] = 'Something went wrong. Let\'s try it again.'
    else
      session[:login_hash] = user.login_hash
      redirect_to admin_url and return
    end

    render :form
  end

  def logout
    @username = current_user.username
    session[:login_hash] = nil
    render :form
  end
end
