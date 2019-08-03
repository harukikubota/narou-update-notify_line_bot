class CreateUserNotifyNovels < ActiveRecord::Migration[5.2]
  def up
    create_table :user_notify_novels do |t|
      t.references :novel, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :notify_novel_type, null: false
      t.integer :notify_novel_episode_no, null: false
      t.timestamps
    end
    add_index :user_notify_novels, :notify_novel_type
  end

  def down
    drop_table :user_notify_novels
  end
end
