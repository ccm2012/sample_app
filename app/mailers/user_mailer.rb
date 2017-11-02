class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: (t "mailer.mailer_active")
  end

  def password_reset; end
end
