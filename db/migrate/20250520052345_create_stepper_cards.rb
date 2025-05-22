class CreateStepperCards < ActiveRecord::Migration[8.0]
  def change
    create_table :stepper_cards do |t|
      t.integer :message_id

      t.timestamps
    end
  end
end
