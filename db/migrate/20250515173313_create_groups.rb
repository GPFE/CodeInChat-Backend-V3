class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id
      t.integer :member_id

      t.timestamps
    end
  end
end
