class UsersController < ApplicationController
  skip_before_action :require_authentication, only: [:create]
  # skip_after_action :refresh_session, only: [:index, :show]
  skip_after_action :refresh_session

  def index
    render json: { users: User.all }
  end

  def show
    render json: { user: "profile info" }
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.create_user_info(bio: "", avatar_icon: "default")
      session = @user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
      render json: { user: @user, token: session.token, user_info: UserInfo.find_by(user_id: @user.id) }, status: 201
    else
      render json: { error: "Cannot create the user." }, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :name)
  end
end
