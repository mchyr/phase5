class UserMailer < ActionMailer::Base
  default from: "michellechyr@gmail.com"
  # no it's not my real email

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def new_user_msg(user)
    @user = user
    mail(:to => user.email, :subject => "New User Account")
end
