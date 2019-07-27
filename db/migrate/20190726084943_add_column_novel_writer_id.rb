class AddColumnNovelWriterId < ActiveRecord::Migration[5.2]
  def up
    change_table :novels do |n|
      n.references :writer, index: true, foreign_key: true
    end
  end

  def down
  end
end

