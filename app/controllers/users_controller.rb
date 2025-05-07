class UsersController < ApplicationController
  skip_before_action :require_authentication, only: [:create]

  def index
    render json: { users: User.all }
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { user: @user }, status: 201
    else
      render json: { error: "Cannot create the user." }, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
