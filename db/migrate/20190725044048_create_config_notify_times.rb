class CreateConfigNotifyTimes < ActiveRecord::Migration[5.2]
  def up
    create_table :config_notify_times do |t|
      t.integer :time_range_start, null: false
      t.integer :time_range_end, null: false
    end
  end

  def down
  end
end
