class Admin::UsersController < AdminController

  before_filter lambda { @title = 'Profile'; @body_class = 'form' }

  def profile
    @user = current_user
  end

  def update
    @user = current_user

    unless @user.authenticate(params[:user][:password_old])
      @user.errors.add(:password_old, 'password is wrong')
      flash.now[:alert] = 'Could not save changes.'
      render :profile and return
    end

    @user.email = params[:user][:email]

    if params[:user][:password]
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      @user.refresh_login_hash
    end

    @user.refresh_api_key if params[:refresh_api_key]

    if @user.save
      session[:login_hash] = @user.login_hash
      flash.now[:notice] = 'Saved changes.'
    else
      flash.now[:alert] = 'Could not save changes.'
    end

    render :profile
  end
end
