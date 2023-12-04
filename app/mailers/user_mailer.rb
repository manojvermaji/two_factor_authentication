class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def otp_email(user, otp)
    @user = user
    @otp = otp
    mail(to: @user.email, subject: 'Your OTP for Two-Factor Authentication')
  end

end
