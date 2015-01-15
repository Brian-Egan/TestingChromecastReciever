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

ActiveRecord::Schema.define(version: 20150113014313) do

  create_table "games", force: true do |t|
    t.text     "room_code"
    t.boolean  "active"
    t.integer  "player_1_id"
    t.text     "player_1_name"
    t.integer  "player_1_score"
    t.text     "player_1_phrase"
    t.integer  "player_2_id"
    t.text     "player_2_name"
    t.integer  "player_2_score"
    t.text     "player_2_phrase"
    t.integer  "player_3_id"
    t.text     "player_3_name"
    t.integer  "player_3_score"
    t.text     "player_3_phrase"
    t.integer  "player_4_id"
    t.text     "player_4_name"
    t.integer  "player_4_score"
    t.text     "player_4_phrase"
    t.integer  "player_5_id"
    t.text     "player_5_name"
    t.integer  "player_5_score"
    t.text     "player_5_phrase"
    t.integer  "player_6_id"
    t.text     "player_6_name"
    t.integer  "player_6_score"
    t.text     "player_6_phrase"
    t.integer  "player_7_id"
    t.text     "player_7_name"
    t.integer  "player_7_score"
    t.text     "player_7_phrase"
    t.integer  "player_8_id"
    t.text     "player_8_name"
    t.integer  "player_8_score"
    t.text     "player_8_phrase"
    t.integer  "player_9_id"
    t.text     "player_9_name"
    t.integer  "player_9_score"
    t.text     "player_9_phrase"
    t.integer  "player_10_id"
    t.text     "player_10_name"
    t.integer  "player_10_score"
    t.text     "player_10_phrase"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.integer  "players",          default: 1
    t.string   "phrases"
  end

  create_table "miscs", force: true do |t|
    t.text     "babble"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phrases", force: true do |t|
    t.string   "text"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "auth_token"
    t.string   "email_address"
    t.string   "sms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
