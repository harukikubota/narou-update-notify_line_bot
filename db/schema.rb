# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_23_195820) do

  create_table "novels", force: :cascade do |t|
    t.string "title", null: false
    t.string "ncode", null: false
    t.integer "last_episode_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rich_menus", force: :cascade do |t|
    t.string "rich_menu_id", null: false
    t.string "name", null: false
    t.string "menu_attribute", default: "default", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_rich_menus_on_name", unique: true
    t.index ["rich_menu_id"], name: "index_rich_menus_on_rich_menu_id", unique: true
  end

  create_table "user_check_novels", force: :cascade do |t|
    t.integer "user_id"
    t.integer "novel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["novel_id"], name: "index_user_check_novels_on_novel_id"
    t.index ["user_id"], name: "index_user_check_novels_on_user_id"
  end

  create_table "user_check_writers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "writer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_check_writers_on_user_id"
    t.index ["writer_id"], name: "index_user_check_writers_on_writer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "line_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enable", default: true, null: false
    t.integer "regist_max", default: 15, null: false
  end

  create_table "writers", force: :cascade do |t|
    t.integer "writer_id", null: false
    t.string "name", null: false
    t.integer "novel_count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
