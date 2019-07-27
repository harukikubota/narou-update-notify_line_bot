class CreateRecommends < ActiveRecord::Migration[5.2]
  def up
    create_table :recommends do |t|
      t.references :novel, index: true, foreign_key: true, unique: true
      t.references :writer, index: true, foreign_key: true, unique: true
      t.integer :rank, unique: true
      t.timestamps
    end
  end

  def down
  end
end
