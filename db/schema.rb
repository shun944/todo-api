# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_04_181647) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "category_masters", force: :cascade do |t|
    t.string "category_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "todos", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "description", limit: 255
    t.string "due_date", limit: 255
    t.boolean "completed"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "category_master_id"
    t.string "start_date"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 255
    t.string "email", limit: 255
    t.string "password", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "password_digest", limit: 255
  end

  add_foreign_key "todos", "category_masters"
  add_foreign_key "todos", "users"
end
