class CreateUserCheckWriters < ActiveRecord::Migration[5.2]
  def change
    create_table :user_check_writers do |t|
      t.references  :user,  index: true, foreign_key: true
      t.references  :writer, index: true, foreign_key: true
      t.timestamps
    end
  end
end
