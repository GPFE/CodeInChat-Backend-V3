class GroupsController < ApplicationController
    skip_after_action :refresh_session

    def index
        render json: { groups: Group.includes(:owner).all.as_json(include: :owner) }
    end

    def join
        user = User.find(Current.session[:user_id])
        group = Group.find(join_group_params[:id])

        unless group
            render json: { error: "Group was not found." }, status: 400
            return
        end

        if group.owner_id == user.id
            render json: { error: "You can't join your own group." }, status: 400
            return
        end
    
        if GroupSubscription.create!(user_id: user.id, group_id: group.id)
            render json: { success: "You've successfully joined this group." }, status: 200
        else
            render json: { error: "You've already joined this group."}, status: 400
        end
    end

    def create
        user = User.find(Current.session[:user_id])
        group = Group.new(owner_id: user.id, name: group_params[:name])

        if group.save!
            render json: { success: "Group was successfully created.", group: Group.includes(:owner).find(group.id).as_json(include: :owner) }, status: 201
        else
            render json: { error: "Group cannot be created." }, status: 400
        end
    end


    private

    def join_group_params
        params.require(:group).permit(:id)
    end

    def group_params
        params.require(:group).permit(:name)
    end
end
