class Admin::LoginController < AdminController
  layout 'aether'

  skip_before_filter :authenticate, except: [:logout]
  before_filter      :forward,      except: [:logout]

  def forward
    redirect_to(admin_url) if current_user
  end

  def form
    @title = 'Login'
  end

  def login
    @title = 'Login'
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
    @title = 'Login'
    @username = current_user.username
    session[:login_hash] = nil
    cookies.delete :remember_me
    render :form
  end

  def forgot_password
    @title = 'Forgot password'
  end

  def request_password_reset
    if (user = User.find_by_email(params[:email]))
      user.refresh_password_reset_hash!
      UserMailer.password_reset(user).deliver
    end

    flash[:notice] = 'We\'ve sent you an email with further instructions.'
    redirect_to admin_login_url
  end

  def reset_password
    @title = 'Reset password'

    unless (@user = User.authenticate_by_reset_hash(params[:reset_hash]))
      flash[:alert] = 'Invalid reset url.'
      redirect_to admin_forgot_password_url
    end
  end

  def update_password
    @title = 'Reset password'

    unless (@user = User.authenticate_by_reset_hash(params[:reset_hash]))
      flash[:alert] = 'Invalid reset url.'
      redirect_to admin_forgot_password_url and return
    end

    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.password_reset_hash = nil

    if @user.save
      flash[:notice] = 'Saved new password'
      redirect_to admin_login_url
    else
      @user.password_reset_hash = @user.password_reset_hash_was
      flash.now[:alert] = 'Could not save new password. Please try again.'
      render :reset_password
    end
  end
end
