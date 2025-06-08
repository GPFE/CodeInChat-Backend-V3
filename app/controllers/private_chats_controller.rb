class PrivateChatsController < ApplicationController
    skip_after_action :refresh_session

    def index
        unless Current.session[:user_id]
            reject_invalid_user
        end


        user = User.find(Current.session[:user_id])

        chatters = user.users_who_messaged_me.as_json(include: :user_info)

        receivers = user
                    .users_who_I_messaged
                    .as_json(include: :user_info)


        render json: { users: [chatters + receivers].flatten().uniq }, status: 200
    end

    def show
        user = User.find(Current.session[:user_id])
        recipient = User.find(params[:recipient_id])

        unless user.sent_messages || recipient.sent_messages
            render json: { success: "No messages yet.", users: [] }, status: 200
            return
        end

        received_messages = recipient
            .sent_messages.includes(:stepper_cards)
            .by_receiver_id(Current.session[:user_id])
            .as_json(include: {:stepper_cards => {include: :steps}}).to_a
        sent_messages = user
            .sent_messages.includes(:stepper_cards)
            .by_receiver_id(params[:recipient_id])
            .as_json(include: {:stepper_cards => {include: :steps}}).to_a

        messages = received_messages.concat(sent_messages)
        sorted_messages = messages.sort_by() { |message| message[:created_at] }
        
        render json: { messages: sorted_messages }, status: 200
    end

    private

    def reject_invalid_user
        render json: { error: "Please log in." }, status: 401
    end
end