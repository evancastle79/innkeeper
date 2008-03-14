# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 17) do

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.boolean  "published",  :default => false
    t.integer  "event_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.datetime "start"
    t.datetime "ends"
    t.integer  "duration"
    t.text     "note"
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "all_day"
    t.integer  "room_id"
    t.decimal  "price_when_saved", :precision => 8, :scale => 2, :default => 0.0
  end

  create_table "events_rooms", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "room_id"
  end

  create_table "events_users", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  create_table "keys", :force => true do |t|
    t.string  "key_actual"
    t.boolean "blocked",    :default => false
    t.integer "event_id"
    t.string  "emailed_to"
  end

  create_table "reservations", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.float    "quoted_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.integer  "location"
    t.boolean  "clean",       :default => true
    t.string   "teaser"
    t.text     "description"
    t.boolean  "occupied",    :default => false
    t.float    "base_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.decimal  "purse",                                   :precision => 8, :scale => 2
  end

end
