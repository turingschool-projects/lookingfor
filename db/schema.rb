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

ActiveRecord::Schema.define(version: 20170220214509) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title",                           null: false
    t.text     "description"
    t.string   "url"
    t.string   "old_location"
    t.date     "posted_date"
    t.boolean  "remote"
    t.text     "raw_technologies",   default: [],              array: true
    t.integer  "company_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "location_id"
    t.integer  "monocle_company_id"
  end

  add_index "jobs", ["company_id"], name: "index_jobs_on_company_id", using: :btree
  add_index "jobs", ["location_id"], name: "index_jobs_on_location_id", using: :btree
  add_index "jobs", ["monocle_company_id"], name: "index_jobs_on_monocle_company_id", using: :btree

  create_table "jobs_technologies", id: false, force: :cascade do |t|
    t.integer "technology_id"
    t.integer "job_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monocle_companies", force: :cascade do |t|
    t.string "name"
  end

  create_table "technologies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "jobs", "companies"
  add_foreign_key "jobs", "locations"
  add_foreign_key "jobs", "monocle_companies"
end
