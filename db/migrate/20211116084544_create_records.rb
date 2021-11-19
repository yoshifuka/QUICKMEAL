class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.integer :dish_id
      t.text :content

      t.timestamps
    end
    add_index :records, :dish_id
  end
end
