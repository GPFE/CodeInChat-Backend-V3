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
end
