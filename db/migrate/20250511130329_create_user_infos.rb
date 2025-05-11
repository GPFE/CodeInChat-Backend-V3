class CreateUserInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :user_infos do |t|
      t.integer :user_id
      t.string :bio
      t.string :avatar_icon

      t.timestamps
    end
  end
end
