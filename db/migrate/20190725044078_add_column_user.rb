class AddColumnUser < ActiveRecord::Migration[5.2]
  def up
    change_table :users do |u|
      u.references :user_config, index: true, foreign_key: true
    end
  end

  def down
  end
end
