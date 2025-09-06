# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20250904091454) do

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "messages", ["room_id"], name: "index_messages_on_room_id"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "room_participants", force: :cascade do |t|
    t.integer  "room_id"
    t.integer  "user_id"
    t.datetime "last_read_at"
  end

  add_index "room_participants", ["room_id"], name: "index_room_participants_on_room_id"
  add_index "room_participants", ["user_id"], name: "index_room_participants_on_user_id"

  create_table "room_requests", force: :cascade do |t|
    t.integer  "room_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "room_requests", ["room_id"], name: "index_room_requests_on_room_id"
  add_index "room_requests", ["user_id"], name: "index_room_requests_on_user_id"

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "private"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "last_message_read_at"
  end

end
