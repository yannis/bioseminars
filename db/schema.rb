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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121116082512) do

  create_table "buildings", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
    t.string   "acronym"
    t.integer  "position"
  end

  create_table "documents", :force => true do |t|
    t.string   "model_type",        :null => false
    t.integer  "model_id",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  add_index "documents", ["model_type", "model_id"], :name => "index_documents_on_model_type_and_model_id"

  create_table "hostings", :force => true do |t|
    t.integer "host_id",    :null => false
    t.integer "seminar_id", :null => false
  end

  add_index "hostings", ["host_id"], :name => "index_hostings_on_host_id"
  add_index "hostings", ["seminar_id"], :name => "index_hostings_on_seminar_id"

  create_table "hosts", :force => true do |t|
    t.string   "name"
    t.string   "affiliation"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description"
    t.integer  "building_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["building_id"], :name => "index_locations_on_building_id"

  create_table "pictures", :force => true do |t|
    t.integer  "model_id",          :null => false
    t.string   "model_type",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  add_index "pictures", ["model_type", "model_id"], :name => "index_pictures_on_model_type_and_model_id"

  create_table "seminars", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start_on"
    t.datetime "end_on"
    t.integer  "location_id"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.boolean  "internal"
    t.boolean  "all_day"
    t.string   "pubmed_ids"
  end

  add_index "seminars", ["category_id"], :name => "index_seminars_on_category_id"
  add_index "seminars", ["location_id"], :name => "index_seminars_on_location_id"
  add_index "seminars", ["user_id"], :name => "index_seminars_on_user_id"

  create_table "speakers", :force => true do |t|
    t.string   "name"
    t.string   "affiliation"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "seminar_id"
  end

  add_index "speakers", ["seminar_id"], :name => "index_speakers_on_seminar_id"

  create_table "users", :force => true do |t|
    t.string   "name",                      :limit => 100, :null => false
    t.string   "email",                     :limit => 100, :null => false
    t.integer  "integer"
    t.string   "encrypted_password",        :limit => 40
    t.string   "password_salt",             :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_code"
    t.boolean  "admin"
    t.string   "persistence_token"
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
