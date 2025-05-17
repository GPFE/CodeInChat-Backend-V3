class RemoveMemberIdFromGroupSubscription < ActiveRecord::Migration[8.0]
  def change
    remove_column :group_subscriptions, :member_id, :integer
  end
end
