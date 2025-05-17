class Group < ApplicationRecord
    has_many :messages, as: :receivable, dependent: :destroy
    belongs_to :owner, class_name: "User"
    has_many :group_subscriptions
    has_many :members, through: :group_subscriptions, source: :user

    # validates :members, uniqueness: true
end
