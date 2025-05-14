class UserInfosController < ApplicationController
    # skip_after_action :refresh_session

    def update
        unless Current.session[:user_id]
            reject_anonymous_user
        end

        user = User.find(Current.session[:user_id])

        if (user.user_info.update(user_info_params))
            session = user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
            p session
            render json: { success: "Your avatar was successfully changed.", user: user, user_info: user.user_info, token: session.token }, status: 200
        else
            render json: { error: "Something went wrong while changing your avatar."}
        end
    end

    private

    def user_info_params
        params.require(:user_info).permit(:avatar_icon)
    end

    def reject_anonymous_user
        render json: { error: "Please log in to enable changing your avatar." }, status: 401
    end
end
