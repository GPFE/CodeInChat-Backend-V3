class Group < ApplicationRecord
    has_many :messages, as: :receivable, dependent: :destroy
    belongs_to :owner, class_name: "User"
    has_many :group_subscriptions
    has_many :members, through: :group_subscriptions, source: :user

    def joined_by?(user)
        members.exists?(user.id)
    end

    def as_json_with_joined(user)
        as_json(include: [:owner, :members]).merge(joined: joined_by?(user))
    end

    def has_user?(user)
        members.exists(user.id) || owner_id == user.id
    end
end
