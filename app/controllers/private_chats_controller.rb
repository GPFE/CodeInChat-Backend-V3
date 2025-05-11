class PrivateChatsController < ApplicationController
    skip_after_action :refresh_session

    def index
        unless Current.session[:user_id]
            reject_invalid_user
        end

        chatters = User.find(Current.session[:user_id]).messages.reduce([]) do |accumulator, message|
            unless accumulator.include?(User.find(message.sender_id))
                accumulator << User.find(message.sender_id)
            end
            accumulator
        end
        
        # chats = User.find(Current.session[:user_id]).messages.reduce(Hash.new()) do |accumulator, message|
        #     if accumulator[message.sender_id]
        #         accumulator[message.sender_id] << message
        #     else
        #         accumulator[message.sender_id] = [message]
        #     end
        # end

        render json: { users: chatters }, status: 200
    end

    def show
        received_messages = User.find(params[:recipient_id])
            .sent_messages.where(receivable_type: "User", receivable_id: Current.session[:user_id]).to_a
        sent_messages = User.find(Current.session[:user_id])
            .sent_messages.where(receivable_type: "User", receivable_id: params[:recipient_id]).to_a

        messages = received_messages.concat(sent_messages)
        sorted_messages = messages.sort_by &:created_at
        
        render json: { messages: sorted_messages }, status: 200
    end

    private

    def reject_invalid_user
        render json: { error: "Please log in." }, status: 401
    end
end