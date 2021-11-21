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

ActiveRecord::Schema.define(version: 20211117025704) do

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password"
  end

  create_table "blocks", force: :cascade do |t|
    t.integer "timeslot_id"
    t.string  "start"
    t.string  "end"
  end

  add_index "blocks", ["timeslot_id"], name: "index_blocks_on_timeslot_id"

  create_table "blocks_invitees", id: false, force: :cascade do |t|
    t.integer "block_id",   null: false
    t.integer "invitee_id", null: false
  end

  add_index "blocks_invitees", ["block_id", "invitee_id"], name: "index_blocks_invitees_on_block_id_and_invitee_id"
  add_index "blocks_invitees", ["invitee_id", "block_id"], name: "index_blocks_invitees_on_invitee_id_and_block_id"

  create_table "invitees", force: :cascade do |t|
    t.string  "email"
    t.integer "votes_left"
    t.integer "poll_id"
  end

  add_index "invitees", ["poll_id"], name: "index_invitees_on_poll_id"

  create_table "polls", force: :cascade do |t|
    t.string  "title"
    t.string  "description"
    t.string  "timezone"
    t.string  "location"
    t.integer "votes_per_user"
    t.integer "votes_per_timeslot"
    t.integer "admin_id"
  end

  create_table "timeslots", force: :cascade do |t|
    t.integer "poll_id"
    t.string  "start"
    t.string  "end"
    t.date    "day"
  end

  add_index "timeslots", ["poll_id"], name: "index_timeslots_on_poll_id"

end
