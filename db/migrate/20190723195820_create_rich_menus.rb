class CreateRichMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :rich_menus do |t|
      t.string :rich_menu_id, null: false
      t.string :name, null: false
      t.timestamps
    end
    add_index :rich_menus, :rich_menu_id, unique: true
    add_index :rich_menus, :name, unique: true
  end
end
