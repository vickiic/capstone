class AddSymptonToHeartrates < ActiveRecord::Migration[5.2]
  def change
    add_column :heartrates, :symptom, :string
  end
end
