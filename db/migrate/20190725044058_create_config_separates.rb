class CreateConfigSeparates < ActiveRecord::Migration[5.2]
  def up
    create_table :config_separates do |t|
      t.string :use_str, limit: 1
    end
    add_index :config_separates, :use_str, unique: true
  end

  def down
  end
end
