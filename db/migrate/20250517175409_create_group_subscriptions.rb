class CreateGroupSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :group_subscriptions do |t|
      t.integer :member_id
      t.integer :group_id

      t.timestamps
    end
  end
end
