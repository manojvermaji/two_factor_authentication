class AuthenticationController < ApplicationController

  def login
    @user = User.find_by_email(params[:email]) 
    if @user&.authenticate(params[:password])
      if @user.two_factor_authentication == true
          @otp = rand.to_s[2..7] 
          @user.update_columns(otp: @otp)
          UserMailer.otp_email(@user, @otp).deliver_now
          render json: {  Otp: @otp }, status: :ok
      else
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
      end
    else
      render json: { error: 'something went wrong' }, status: :unauthorized
    end
  end

   
  def otp_confirmation
    @user = User.find_by_email(params[:email])
    if @user && @user.otp == params[:otp]
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
    else
      render json: { error: 'Invalid OTP' }, status: :unauthorized
    end
  end
    
  def password_change
    @user = User.find_by_email(params[:email]) 
    if @user.two_factor_authentication == true
      @otp = rand.to_s[2..7] 
      @user.update_columns(otp: @otp)
      UserMailer.otp_email(@user, @otp).deliver_now
      render json: {  Otp: @otp }, status: :ok
    else
      @user.update(login_params)
      render json: { message: "password change successfull", user: @user}, status: :ok
    end
  end

   
  def otp_confirmation_for_password_change
    @user = User.find_by_email(params[:email])
    if @user && @user.otp == params[:otp]
      @user.update(login_params)
      render json: { message: "password change successfull", user: @user}, status: :ok
    else
      render json: { error: 'Invalid OTP' }, status: :unauthorized
    end
  end


  private

  def login_params
    params.permit(:email, :password)
  end
end
