class AddPostedAtNovel < ActiveRecord::Migration[5.2]
  def up
    add_column :novels, :posted_at, :datetime
  end

  def down
  end
end
