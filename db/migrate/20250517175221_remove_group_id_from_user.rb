class RemoveGroupIdFromUser < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :group_id, :integer
  end
end
