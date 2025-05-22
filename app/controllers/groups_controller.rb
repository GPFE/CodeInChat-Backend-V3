class GroupsController < ApplicationController
    skip_after_action :refresh_session

    def index
        user = User.find(Current.session[:user_id])

        groups = Group.includes(:owner, :members).all.as_json(include: [:owner, :members])
        new_groups = groups.map() do |group|
            if group&.dig("members")&.select() { |member| member["id"] == user.id }&.length > 0
                group.merge({ joined: true })
            else
                group.merge({ joined: false })
            end
        end

        render json: { groups: new_groups }
    end

    def show
        group = Group.includes(:messages).find(params[:id]).as_json(include: { :messages => { :include => :sender } })

        render json: { group: group }
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

    def messages
        group = Group.includes(:messages).find(params[:id])
        user = User.find(Current.session[:user_id])

        unless Group.includes(:members).find(message_params[:receivable_id]).members.select() { |member| member.id == user.id } || Group.find(message_params[:receivable_id]).owner_id == user.id
            reject_invalid_user
            return
        end

        render json: { messages: group.messages }
    end

    def joined_groups
        user = User.find(Current.session[:user_id])

        render json: { groups: user.groups + user.owned_groups }, status: 200
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

    private

    def join_group_params
        params.require(:group).permit(:id)
    end

    def group_params
        params.require(:group).permit(:name)
    end

    def reject_invalid_user
        render json: { error: "Invalid user." }, status: 401
    end
end
