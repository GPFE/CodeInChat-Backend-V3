class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [:create]
  
  def create
    if user = User.authenticate_by(email_address: params[:user][:email_address], password: params[:user][:password])
      session = user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)

      cookies.encrypted[:session_token] = {
        value: session.token,
        httponly: true,
        secure: Rails.env.production?,
        expires: 2.weeks.from_now
      }

      render json: { token: session.token, user: user, user_info: UserInfo.find_by(user_id: user.id) }, status: :created
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def destroy
    user = User.find(Current.session[:user_id])
    cookies.encrypted[:user_id] = nil
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
    render json: { success: "You were successfully logged out." }, status: 204
  end
end