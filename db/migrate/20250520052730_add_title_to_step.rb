class AddTitleToStep < ActiveRecord::Migration[8.0]
  def change
    add_column :steps, :title, :string
  end
end
