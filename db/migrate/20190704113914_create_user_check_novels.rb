class CreateUserCheckNovels < ActiveRecord::Migration[5.2]
  def change
    create_table :user_check_novels do |t|
      t.references  :user,  index: true, foreign_key: true
      t.references  :novel, index: true, foreign_key: true
      t.timestamps
    end
  end
end
