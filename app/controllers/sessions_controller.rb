class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [:create]
  def create
    if user = User.authenticate_by(email_address: params[:user][:email_address], password: params[:user][:password])
      session = user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
      render json: { token: session.token, user: user }, status: :created
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
  # Optional: Implement destroy action for logging out
  def destroy
    Current.session.destroy
    head :no_content
  end
end