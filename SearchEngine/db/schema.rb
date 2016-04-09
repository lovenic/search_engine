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

ActiveRecord::Schema.define(version: 20151212121547) do

  create_table "locations", force: :cascade do |t|
    t.integer  "position",   limit: 4
    t.string   "word_area",  limit: 255
    t.integer  "word_id",    limit: 4
    t.integer  "page_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "locations", ["page_id"], name: "index_locations_on_page_id", using: :btree
  add_index "locations", ["word_id"], name: "index_locations_on_word_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "url",        limit: 10000
    t.string   "title",      limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "words", force: :cascade do |t|
    t.string   "stem",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "locations", "pages"
  add_foreign_key "locations", "words"
end
