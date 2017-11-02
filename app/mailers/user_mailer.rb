class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: (t "mailer.mailer_active")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: (t "controller.mailer_pass_reset")
  end
end
