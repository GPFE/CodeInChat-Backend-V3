class GroupsController < ApplicationController
    skip_after_action :refresh_session

    def create
        user = User.find(Current.session[:user_id])

        if Group.create!(owner_id: user.id, name: group_params[:name])
            render json: { success: "Group was successfully created." }, status: 201
        else
            render json: { error: "Group cannot be created." }, status: 400
        end
    end


    private

    def group_params
        params.require(:group).permit(:name)
    end
end
