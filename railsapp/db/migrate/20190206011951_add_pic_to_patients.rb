class AddPicToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :pic, :string
  end
end
