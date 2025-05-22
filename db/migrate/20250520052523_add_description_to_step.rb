class AddDescriptionToStep < ActiveRecord::Migration[8.0]
  def change
    add_column :steps, :description, :string
  end
end
