class CreateHeartrates < ActiveRecord::Migration[5.2]
  def change
    create_table :heartrates do |t|
      t.string :device
      t.integer :value
      t.string :time

      t.timestamps
    end
  end
end
