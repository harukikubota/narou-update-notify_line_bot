class CreateWriters < ActiveRecord::Migration[5.2]
  def up
    create_table :writers do |t|
      t.integer :writer_id, null: false
      t.string :name, null: false
      t.integer :novel_count, null: false
      t.timestamps
    end
  end

  def down
  end
end
