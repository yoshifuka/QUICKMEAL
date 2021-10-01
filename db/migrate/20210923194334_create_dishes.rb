class CreateDishes < ActiveRecord::Migration[6.0]
  def change
    create_table :dishes do |t|
      t.string :name
      t.text :description
      t.integer :portion
      t.integer :required_time
      t.text :tips
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :dishes, [:user_id, :created_at]
  end
end
