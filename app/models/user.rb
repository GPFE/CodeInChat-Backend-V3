class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :messages, as: :receivable
  has_many :sent_messages, foreign_key: "sender_id", class_name: "Message"
  has_one :user_info
  belongs_to :groups, foreign_key: "member_id", class_name: "Group"
  has_many :owned_groups, foreign_key: "owner_id", class_name: "Group"

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
