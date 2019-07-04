class CreateNovels < ActiveRecord::Migration[5.2]
  def change
    create_table :novels do |t|
      t.string :title, null: false
      t.string :ncode, null: false
      t.integer :last_episode_id, null: false

      t.timestamps
    end
  end
end
