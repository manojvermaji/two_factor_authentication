class UsersController < ApplicationController
  before_action :authorize_request,except: %i[create update]
  before_action :find_user, except: %i[create index ]

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)    
      if @user.save
        UserMailer.welcome_email(@user).deliver_now
        render json: @user, status: :created
      else
        render json: { errors: @user.errors.full_messages },
              status: :unprocessable_entity
      end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end


  def destroy
    @user.destroy
  end

  private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:email, :password, :two_factor_authentication)
    end

  
end
