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

ActiveRecord::Schema.define(version: 20140414141751) do

  create_table "buildings", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "color"
    t.string   "acronym"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived_at"
  end

  add_index "categories", ["archived_at"], name: "index_categories_on_archived_at", using: :btree

  create_table "categorisations", force: true do |t|
    t.integer  "category_id"
    t.integer  "seminar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: true do |t|
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["documentable_id", "documentable_type"], name: "index_documents_on_documentable_id_and_documentable_type", using: :btree

  create_table "hostings", force: true do |t|
    t.integer  "host_id"
    t.integer  "seminar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hosts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.integer  "building_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["building_id"], name: "index_locations_on_building_id", using: :btree

  create_table "pictures", force: true do |t|
    t.integer  "model_id",          null: false
    t.string   "model_type",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  add_index "pictures", ["model_type", "model_id"], name: "index_pictures_on_model_type_and_model_id", using: :btree

  create_table "seminars", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "speaker_name"
    t.string   "speaker_affiliation"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "url"
    t.integer  "location_id"
    t.integer  "user_id"
    t.boolean  "all_day"
    t.boolean  "internal"
    t.string   "pubmed_ids"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seminars", ["location_id"], name: "index_seminars_on_location_id", using: :btree
  add_index "seminars", ["user_id"], name: "index_seminars_on_user_id", using: :btree

  create_table "speakers", force: true do |t|
    t.string   "name"
    t.string   "affiliation"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "seminar_id"
  end

  add_index "speakers", ["seminar_id"], name: "index_speakers_on_seminar_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.boolean  "admin",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
