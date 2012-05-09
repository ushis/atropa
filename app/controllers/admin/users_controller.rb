class Admin::UsersController < AdminController

  def edit
    @title = 'Profile'
    @bodyclass = 'form'
    @user = current_user
  end

  def update
    @title = 'Profile'
    @bodyclass = 'form'
    @user = current_user

    unless @user.authenticate(params[:user][:password_old])
      @user.errors.add(:password_old, 'password is wrong')
      flash.now[:alert] = 'Could not save changes.'
      render :edit and return
    end

    @user.email = params[:user][:email]

    if params[:user][:password]
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
    end

    flash.now[:alert] = 'Could not save changes.' unless @user.save
    render :edit
  end
end
