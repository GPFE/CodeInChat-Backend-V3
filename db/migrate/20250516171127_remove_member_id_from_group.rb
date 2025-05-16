class RemoveMemberIdFromGroup < ActiveRecord::Migration[8.0]
  def change
    remove_column :groups, :member_id, :integer
  end
end
