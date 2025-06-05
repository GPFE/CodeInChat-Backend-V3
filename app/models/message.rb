class Message < ApplicationRecord
    belongs_to :sender, class_name: "User", foreign_key: "sender_id"
    belongs_to :receivable, polymorphic: true
    has_many :stepper_cards

    # validates :sender_id, :receiver_id, :chat_id, presence: true

    def self.by_receiver_id(recipient_id)
        where(receivable_type: "User", receivable_id: recipient_id)
    end
end
