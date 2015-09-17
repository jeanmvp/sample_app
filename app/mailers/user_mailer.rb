class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Activación de la cuenta"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Recuperar contraseña"
  end
end
