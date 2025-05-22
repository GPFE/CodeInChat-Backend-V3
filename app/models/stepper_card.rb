class StepperCard < ApplicationRecord
    has_many :steps
    belongs_to :message
end
