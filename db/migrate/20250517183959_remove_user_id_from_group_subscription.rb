class RemoveUserIdFromGroupSubscription < ActiveRecord::Migration[8.0]
  def change
    remove_column :group_subscriptions, :user_id, :integer
  end
end
