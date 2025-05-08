class Chat < ApplicationRecord
    has_many :messages, as: receivable
end
