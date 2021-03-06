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

ActiveRecord::Schema.define(version: 20171222153306) do

  create_table "feeds", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.boolean "is_enabled"
    t.integer "amount"
    t.datetime "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "cover"
    t.string "cover_type"
    t.integer "offset"
    t.integer "total_ep_count"
    t.boolean "is_finished"
    t.boolean "auto_finish"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "info_hash"
    t.integer "feed_id"
    t.text "url"
    t.integer "taskid"
    t.integer "ep_id"
    t.boolean "skip", default: false
    t.string "media_path"
  end

end
