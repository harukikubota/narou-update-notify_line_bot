class AddColumnToUserRegistMax < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :regist_max, :integer, null: false, default: 15
  end

  def down

  end
end
