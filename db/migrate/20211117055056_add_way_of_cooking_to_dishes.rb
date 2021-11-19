class AddWayOfCookingToDishes < ActiveRecord::Migration[6.0]
  def change
    add_column :dishes, :way_of_cooking, :text
  end
end
