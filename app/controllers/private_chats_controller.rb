class PrivateChatsController < ApplicationController
    skip_after_action :refresh_session

    def index
        unless Current.session[:user_id]
            reject_invalid_user
        end

        user = User.find(Current.session[:user_id])

        chatters = user.messages.reduce([]) do |accumulator, message|
            unless accumulator.include?(User.find(message.sender_id).as_json(include: :user_info))
                accumulator << User.includes(:user_info).find(message.sender_id).as_json(include: :user_info)
            end
            accumulator
        end

        receiver_ids = user.sent_messages.map() { |message|  message.receivable_id }.uniq
        receivers = receiver_ids.map() { |receiver_id| User.includes(:user_info).find(receiver_id).as_json(include: :user_info) }


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
            .where(receivable_type: "User", receivable_id: Current.session[:user_id])
            .as_json(include: {:stepper_cards => {include: :steps}}).to_a
        sent_messages = user
            .sent_messages.includes(:stepper_cards)
            .where(receivable_type: "User", receivable_id: params[:recipient_id])
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