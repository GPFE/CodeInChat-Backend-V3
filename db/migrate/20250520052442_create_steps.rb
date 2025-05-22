class CreateSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :steps do |t|
      t.integer :stepper_card_id
      t.integer :index
      t.string :language
      t.string :code

      t.timestamps
    end
  end
end
