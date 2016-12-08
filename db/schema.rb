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

ActiveRecord::Schema.define(version: 20161208020725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_numbers", force: :cascade do |t|
    t.string   "area"
    t.string   "name"
    t.string   "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lead_sources", force: :cascade do |t|
    t.string   "name",              null: false
    t.string   "incoming_number",   null: false
    t.string   "forwarding_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leads", force: :cascade do |t|
    t.integer  "lead_source_id", null: false
    t.string   "phone_number",   null: false
    t.string   "city"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_numbers", force: :cascade do |t|
    t.string   "name"
    t.string   "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "support_numbers", force: :cascade do |t|
    t.string   "name"
    t.string   "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "leads", "lead_sources"
end
