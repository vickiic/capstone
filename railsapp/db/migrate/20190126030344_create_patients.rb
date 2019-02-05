class CreatePatients < ActiveRecord::Migration[5.2]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :device
      t.integer :age
      t.integer :weight

      t.timestamps
    end
  end
end
