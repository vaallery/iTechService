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

ActiveRecord::Schema.define(:version => 20130523110318) do

  create_table "announcements", :force => true do |t|
    t.string   "content"
    t.string   "kind",       :null => false
    t.integer  "user_id",    :null => false
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "announcements", ["kind"], :name => "index_announcements_on_kind"
  add_index "announcements", ["user_id"], :name => "index_announcements_on_user_id"

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
    t.string   "surname"
    t.string   "patronymic"
    t.date     "birthday"
    t.string   "email"
    t.text     "admin_info"
    t.string   "contact_phone"
  end

  add_index "clients", ["card_number"], :name => "index_clients_on_card_number"
  add_index "clients", ["email"], :name => "index_clients_on_email"
  add_index "clients", ["full_phone_number"], :name => "index_clients_on_full_phone_number"
  add_index "clients", ["name"], :name => "index_clients_on_name"
  add_index "clients", ["patronymic"], :name => "index_clients_on_patronymic"
  add_index "clients", ["phone_number"], :name => "index_clients_on_phone_number"
  add_index "clients", ["surname"], :name => "index_clients_on_surname"

  create_table "comments", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.integer  "commentable_id",   :null => false
    t.string   "commentable_type", :null => false
    t.text     "content",          :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "device_tasks", :force => true do |t|
    t.integer  "device_id"
    t.integer  "task_id"
    t.boolean  "done"
    t.text     "comment"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.decimal  "cost"
    t.datetime "done_at"
    t.text     "user_comment"
  end

  add_index "device_tasks", ["device_id"], :name => "index_device_tasks_on_device_id"
  add_index "device_tasks", ["done"], :name => "index_device_tasks_on_done"
  add_index "device_tasks", ["done_at"], :name => "index_device_tasks_on_done_at"
  add_index "device_tasks", ["task_id"], :name => "index_device_tasks_on_task_id"

  create_table "device_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "ancestry"
    t.integer  "qty_for_replacement", :default => 0
    t.integer  "qty_replaced",        :default => 0
    t.integer  "qty_shop"
    t.integer  "qty_store"
    t.integer  "qty_reserve"
    t.integer  "expected_during"
    t.integer  "code_1c"
  end

  add_index "device_types", ["ancestry"], :name => "index_device_types_on_ancestry"
  add_index "device_types", ["code_1c"], :name => "index_device_types_on_code_1c"
  add_index "device_types", ["name"], :name => "index_device_types_on_name"

  create_table "devices", :force => true do |t|
    t.integer  "device_type_id"
    t.string   "ticket_number"
    t.integer  "client_id"
    t.text     "comment"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "done_at"
    t.string   "serial_number"
    t.integer  "location_id"
    t.integer  "user_id"
    t.string   "security_code"
    t.string   "status"
    t.string   "imei"
    t.boolean  "replaced",        :default => false
    t.boolean  "notify_client",   :default => false
    t.boolean  "client_notified", :default => false
  end

  add_index "devices", ["client_id"], :name => "index_devices_on_client_id"
  add_index "devices", ["device_type_id"], :name => "index_devices_on_device_type_id"
  add_index "devices", ["done_at"], :name => "index_devices_on_done_at"
  add_index "devices", ["imei"], :name => "index_devices_on_imei"
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

  create_table "gift_certificates", :force => true do |t|
    t.string   "number"
    t.integer  "nominal"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "consumed"
  end

  add_index "gift_certificates", ["number"], :name => "index_gift_certificates_on_number"

  create_table "history_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "column_name"
    t.string   "column_type"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "old_value"
    t.text     "new_value"
  end

  add_index "history_records", ["column_name"], :name => "index_history_records_on_column_name"
  add_index "history_records", ["object_id", "object_type"], :name => "index_history_records_on_object_id_and_object_type"
  add_index "history_records", ["user_id"], :name => "index_history_records_on_user_id"

  create_table "infos", :force => true do |t|
    t.string   "title",                           :null => false
    t.text     "content",                         :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "important",    :default => false
    t.integer  "recipient_id"
    t.boolean  "is_archived",  :default => false
  end

  add_index "infos", ["recipient_id"], :name => "index_infos_on_recipient_id"
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
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.boolean  "schedule"
    t.integer  "position",   :default => 0
  end

  add_index "locations", ["ancestry"], :name => "index_locations_on_ancestry"
  add_index "locations", ["name"], :name => "index_locations_on_name"
  add_index "locations", ["schedule"], :name => "index_locations_on_schedule"

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "messages", ["recipient_id"], :name => "index_messages_on_recipient_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

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
    t.integer  "user_id"
    t.text     "user_comment"
  end

  add_index "orders", ["customer_id", "customer_type"], :name => "index_orders_on_customer_id_and_customer_type"
  add_index "orders", ["customer_id"], :name => "index_orders_on_customer_id"
  add_index "orders", ["object_kind"], :name => "index_orders_on_object_kind"
  add_index "orders", ["status"], :name => "index_orders_on_status"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "prices", :force => true do |t|
    t.string   "file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "salaries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "salaries", ["user_id"], :name => "index_salaries_on_user_id"

  create_table "sales", :force => true do |t|
    t.integer  "device_type_id"
    t.string   "imei"
    t.string   "serial_number"
    t.datetime "sold_at"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "quantity"
  end

  add_index "sales", ["device_type_id"], :name => "index_sales_on_device_type_id"
  add_index "sales", ["imei"], :name => "index_sales_on_imei"
  add_index "sales", ["serial_number"], :name => "index_sales_on_serial_number"

  create_table "schedule_days", :force => true do |t|
    t.integer  "user_id"
    t.integer  "day"
    t.string   "hours"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "schedule_days", ["day"], :name => "index_schedule_days_on_day"
  add_index "schedule_days", ["user_id"], :name => "index_schedule_days_on_user_id"

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.string   "presentation"
    t.string   "value"
    t.string   "value_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "settings", ["name"], :name => "index_settings_on_name"

  create_table "stolen_phones", :force => true do |t|
    t.string   "imei",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stolen_phones", ["imei"], :name => "index_stolen_phones_on_imei"

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.integer  "duration"
    t.decimal  "cost"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "priority",    :default => 0
    t.string   "role"
    t.integer  "location_id"
  end

  add_index "tasks", ["location_id"], :name => "index_tasks_on_location_id"
  add_index "tasks", ["name"], :name => "index_tasks_on_name"
  add_index "tasks", ["role"], :name => "index_tasks_on_role"

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
    t.string   "card_number"
    t.string   "color"
    t.integer  "abilities_mask"
    t.boolean  "schedule"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["card_number"], :name => "index_users_on_card_number"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["location_id"], :name => "index_users_on_location_id"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["patronymic"], :name => "index_users_on_patronymic"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["schedule"], :name => "index_users_on_schedule"
  add_index "users", ["surname"], :name => "index_users_on_surname"
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "wiki_page_attachments", :force => true do |t|
    t.integer  "page_id",                           :null => false
    t.string   "wiki_page_attachment_file_name"
    t.string   "wiki_page_attachment_content_type"
    t.integer  "wiki_page_attachment_file_size"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "wiki_page_versions", :force => true do |t|
    t.integer  "page_id",    :null => false
    t.integer  "updator_id"
    t.integer  "number"
    t.string   "comment"
    t.string   "path"
    t.string   "title"
    t.text     "content"
    t.datetime "updated_at"
  end

  add_index "wiki_page_versions", ["page_id"], :name => "index_wiki_page_versions_on_page_id"
  add_index "wiki_page_versions", ["updator_id"], :name => "index_wiki_page_versions_on_updator_id"

  create_table "wiki_pages", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "updator_id"
    t.string   "path"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "wiki_pages", ["creator_id"], :name => "index_wiki_pages_on_creator_id"
  add_index "wiki_pages", ["path"], :name => "index_wiki_pages_on_path", :unique => true

end
