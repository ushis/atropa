class Admin::UsersController < AdminController

  def edit
    @title = 'Profile'
    @bodyclass = 'form'
    @user = current_user
  end

  def update

  end
end
