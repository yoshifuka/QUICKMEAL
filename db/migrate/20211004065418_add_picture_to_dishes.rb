class AddPictureToDishes < ActiveRecord::Migration[6.0]
  def change
    add_column :dishes, :picture, :string
  end
end
