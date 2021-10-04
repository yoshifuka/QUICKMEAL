class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :dish_id
      t.string :quantity

      t.timestamps
    end
    add_index :ingredients, :dish_id 
  end
end
