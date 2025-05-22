class MessagesController < ApplicationController
    skip_after_action :refresh_session

    def create
        message = Message.new(message_params)

        unless message.sender || message.receivable || message.content
            reject_invalid_message
            return
        end

        if message_params[:receivable_type] == "Group"
            user = User.find(Current.session[:user_id])
            group = Group.includes(:members).find(message_params[:receivable_id])

            unless group.members.select() { |member| member.id == user.id } || group.owner_id == user.id
                reject_invalid_user
                return
            end
        end

        p params

        if message.valid?
            stepper_card = message.stepper_cards.build()
            steps = stepper_card.steps.build(attachments_params[:codeSteps])

            if message.save
                render json: { success: "Message was created successfully", message: message.as_json(include: { stepper_cards: { include: :steps } }) }, status: 201
            else
                reject_invalid_message
            end
        else
            reject_invalid_message
        end
    end

    private

    def message_params
        params.require(:message).permit(:sender_id, :receivable_id, :receivable_type, :content)
    end

    def attachments_params
        params.require(:message).permit(codeSteps: [:title, :code, :language, :description])
    end

    def reject_invalid_message
        render json: { error: "Invalid message." }, status: 401
    end

    def reject_invalid_user
        render json: { error: "Invalid user." }, status: 401
    end
end
