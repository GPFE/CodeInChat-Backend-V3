class AddGroupIdToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :group_id, :integer
  end
end
