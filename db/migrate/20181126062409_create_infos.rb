class CreateInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :infos do |t|
      t.string :name
      t.integer :uid

      t.timestamps
    end
  end
end
