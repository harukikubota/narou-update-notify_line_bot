class AddColumnNovelDeleted < ActiveRecord::Migration[5.2]
  def up
    add_column :novels, :deleted, :boolean, default: false
    add_column :novels, :deleted_at, :datetime
  end

  def down
    remove_column :novels, :deleted
    remove_column :novels, :deleted_at
  end
end
