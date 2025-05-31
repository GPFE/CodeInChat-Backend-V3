class Session < ApplicationRecord
  belongs_to :user
  before_create :generate_token

  def regenerate_token!
    generate_token
    save!
  end

  private

  def generate_token
    self.token = SecureRandom.hex(32)
  end
end