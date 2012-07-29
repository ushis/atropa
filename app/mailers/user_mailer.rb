class UserMailer < ActionMailer::Base
  default from: 'atropa@wurstcase.net'

  def password_reset(user)
    @user = user
    mail(to: user.email, subject: '[atropa] password reset')
  end
end
