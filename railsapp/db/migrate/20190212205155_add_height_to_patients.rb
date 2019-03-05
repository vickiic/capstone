class AddHeightToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :height, :string
  end
end
