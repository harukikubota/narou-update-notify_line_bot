class AddColumnNotifiedToUserNotifyNovel < ActiveRecord::Migration[5.2]
  def up
    change_table :user_notify_novels do |u|
      u.boolean :notified, null: false, default: false
      u.datetime :notified_at
    end
  end

  def down
    remove_column :user_notify_novels, :notified
    remove_column :user_notify_novels, :notified_at
  end
end
