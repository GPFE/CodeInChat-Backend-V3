class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :messages, as: :receivable, dependent: :destroy
  has_many :sent_messages, foreign_key: "sender_id", class_name: "Message", dependent: :destroy

  has_one :user_info, dependent: :destroy

  has_many :owned_groups, foreign_key: "owner_id", class_name: "Group", dependent: :destroy
  has_many :group_subscriptions
  has_many :groups, through: :group_subscriptions

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def users_who_messaged_me
    sender_ids = messages.pluck(:sender_id).uniq
    senders = User.includes(:user_info).where(id: sender_ids)
  end

  def users_who_I_messaged
      receiver_ids = sent_messages
        .where(receivable_type: "User")
        .pluck(:receivable_id).uniq
      receivers = User
        .includes(:user_info)
        .where(id: receiver_ids)
  end
end
