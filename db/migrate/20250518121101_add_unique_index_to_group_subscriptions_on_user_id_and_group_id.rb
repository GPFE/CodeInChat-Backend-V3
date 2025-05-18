class AddUniqueIndexToGroupSubscriptionsOnUserIdAndGroupId < ActiveRecord::Migration[8.0]
  def change
    add_index :group_subscriptions, [:user_id, :group_id], unique: true, name: 'index_group_subs_on_user_id_and_group_id'
  end
end
