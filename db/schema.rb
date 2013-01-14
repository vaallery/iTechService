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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130114112740) do

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "card_number"
    t.string   "full_phone_number"
  end

  add_index "clients", ["full_phone_number"], :name => "index_clients_on_full_phone_number"

  create_table "device_tasks", :force => true do |t|
    t.integer  "device_id"
    t.integer  "task_id"
    t.boolean  "done"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.decimal  "cost"
    t.datetime "done_at"
  end

  add_index "device_tasks", ["device_id"], :name => "index_device_tasks_on_device_id"
  add_index "device_tasks", ["task_id"], :name => "index_device_tasks_on_task_id"

  create_table "device_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "ancestry"
    t.integer  "qty_for_replacement", :default => 0
    t.integer  "qty_replaced",        :default => 0
  end

  add_index "device_types", ["ancestry"], :name => "index_device_types_on_ancestry"

  create_table "devices", :force => true do |t|
    t.integer  "device_type_id"
    t.string   "ticket_number"
    t.integer  "client_id"
    t.text     "comment"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.datetime "done_at"
    t.string   "serial_number"
    t.integer  "location_id"
    t.integer  "user_id"
    t.string   "emei"
    t.boolean  "replaced",       :default => false
    t.string   "security_code"
    t.string   "status"
  end

  add_index "devices", ["client_id"], :name => "index_devices_on_client_id"
  add_index "devices", ["device_type_id"], :name => "index_devices_on_device_type_id"
  add_index "devices", ["location_id"], :name => "index_devices_on_location_id"
  add_index "devices", ["status"], :name => "index_devices_on_status"
  add_index "devices", ["ticket_number"], :name => "index_devices_on_ticket_number"
  add_index "devices", ["user_id"], :name => "index_devices_on_user_id"

  create_table "duty_days", :force => true do |t|
    t.integer  "user_id"
    t.date     "day"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "duty_days", ["day"], :name => "index_duty_days_on_day"
  add_index "duty_days", ["user_id"], :name => "index_duty_days_on_user_id"

  create_table "history_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "column_name"
    t.string   "column_type"
    t.string   "old_value"
    t.string   "new_value"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "history_records", ["new_value"], :name => "index_history_records_on_new_value"
  add_index "history_records", ["object_id", "object_type"], :name => "index_history_records_on_object_id_and_object_type"
  add_index "history_records", ["old_value", "new_value"], :name => "index_history_records_on_old_value_and_new_value"
  add_index "history_records", ["old_value"], :name => "index_history_records_on_old_value"
  add_index "history_records", ["user_id"], :name => "index_history_records_on_user_id"

  create_table "infos", :force => true do |t|
    t.string   "title",                         :null => false
    t.text     "content",                       :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "important",  :default => false
  end

  add_index "infos", ["title"], :name => "index_infos_on_title"

  create_table "karmas", :force => true do |t|
    t.boolean  "good"
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "karmas", ["user_id"], :name => "index_karmas_on_user_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "ancestry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "locations", ["ancestry"], :name => "index_locations_on_ancestry"

  create_table "orders", :force => true do |t|
    t.string   "number"
    t.integer  "customer_id"
    t.string   "customer_type"
    t.string   "object_kind"
    t.string   "object"
    t.date     "desired_date"
    t.string   "status"
    t.text     "comment"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "orders", ["customer_id"], :name => "index_orders_on_customer_id"
  add_index "orders", ["object_kind"], :name => "index_orders_on_object_kind"
  add_index "orders", ["status"], :name => "index_orders_on_status"

  create_table "schedule_days", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day"
    t.string   "hours"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "schedule_days", ["day"], :name => "index_schedule_days_on_day"
  add_index "schedule_days", ["user_id"], :name => "index_schedule_days_on_user_id"

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.integer  "duration"
    t.decimal  "cost"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "priority",   :default => 0
    t.string   "role"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "role"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "email",                  :default => ""
    t.integer  "location_id"
    t.string   "photo"
    t.string   "surname"
    t.string   "name"
    t.string   "patronymic"
    t.date     "birthday"
    t.date     "hiring_date"
    t.date     "salary_date"
    t.string   "prepayment"
    t.text     "wish"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["location_id"], :name => "index_users_on_location_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username"

end
