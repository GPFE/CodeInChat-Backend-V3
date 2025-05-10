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

    private

    def reject_invalid_user
        render json: { error: "Please log in." }, status: 401
    end
end