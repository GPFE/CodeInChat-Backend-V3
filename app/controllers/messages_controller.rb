class MessagesController < ApplicationController
    skip_after_action :refresh_session

    def create
        message = Message.new(message_params)

        unless message.sender || message.receivable || message.content
            reject_invalid_message
        end

        if message.save
            render json: { success: "Message was created successfully", message: message }, status: 201
        else
            reject_invalid_message
        end
    end

    private

    def message_params
        params.require(:message).permit(:sender_id, :receivable_id, :receivable_type, :content)
    end

    def reject_invalid_message
        render json: { error: "Invalid message." }, status: 401
    end
end
