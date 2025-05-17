class AddUserIdToGroupSubscription < ActiveRecord::Migration[8.0]
  def change
    add_column :group_subscriptions, :user_id, :integer
  end
end
