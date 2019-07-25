class CreateUserConfigs < ActiveRecord::Migration[5.2]
  def up
    create_table :user_configs do |t|
      t.references  :config_notify_time, index: true, foreign_key: true, unique: true
      t.references  :config_separate, index: true, foreign_key: true
      t.timestamps
    end
  end

  def down
  end
end
