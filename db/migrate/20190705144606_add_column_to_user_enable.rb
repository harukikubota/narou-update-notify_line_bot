class AddColumnToUserEnable < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :enable, :boolean, null: false, default: true
  end

  def down

  end
end
