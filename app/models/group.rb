class Group < ApplicationRecord
    has_many :messages, as: :receivable
    has_many :members, class_name: "User"
    belongs_to :owner, class_name: "User"
end
