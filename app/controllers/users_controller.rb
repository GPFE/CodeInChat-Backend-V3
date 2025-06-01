class UsersController < ApplicationController
  skip_before_action :require_authentication, only: [:create]
  # skip_after_action :refresh_session, only: [:index, :show]
  skip_after_action :refresh_session

  def index
    user = User.includes(:user_info).all
    render json: { users: user.as_json(include: :user_info) }
  end

  def show
    render json: { user: "profile info" }
  end

  def create
    user = User.new(user_params)

    if user.save!
      user.create_user_info(bio: "", avatar_icon: "default")
      session = user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)

      cookies.encrypted[:session_token] = {
        value: session.token,
        httponly: true,
        secure: Rails.env.production?,
        expires: 2.weeks.from_now
      }

      render json: { user: user.as_json, user_info: UserInfo.find_by(user_id: user.id) }, status: 201
    else
      render json: { error: "Cannot create the user." }, status: 400
    end
  end

  def update
    user = User.find(Current.session[:user_id])

    if user.update!(user_update_params)
      session = user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
      render json: { user: user, user_info: user.user_info, token: session.token, success: "Your data were successfully updated." }, status: 200
    else
      render json: { error: "Cannot update your data." }, status: 401
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :name)
  end

  def user_update_params 
    params.require(:user).permit(:email_address, :name)
  end
end
