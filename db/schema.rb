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

ActiveRecord::Schema.define(:version => 20131123050654) do

  create_table "accounts", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "alias",                                  :null => false
    t.string   "token",                                  :null => false
    t.string   "app_id"
    t.string   "app_secret"
    t.string   "access_token"
    t.string   "identifier"
    t.text     "description"
    t.datetime "updated_access_token_at"
    t.integer  "expires_in",              :default => 0
    t.integer  "members_count",           :default => 0
    t.integer  "kits_count",              :default => 0
    t.integer  "menus_count",             :default => 0
    t.integer  "replies_count",           :default => 0
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "votes_count",             :default => 0
    t.integer  "maps_count",              :default => 0
    t.integer  "merchants_count"
  end

  add_index "accounts", ["alias"], :name => "index_accounts_on_alias"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "avatar"
    t.string   "realname",               :limit => 60
    t.integer  "roles_mask",                           :default => 0
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "album_profiles", :force => true do |t|
    t.integer  "album_id",   :default => 0
    t.integer  "type_cd",    :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "article_profiles", :force => true do |t|
    t.integer  "article_id", :default => 0
    t.text     "body"
    t.string   "url"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "audio_profiles", :force => true do |t|
    t.integer  "audio_id",      :default => 0
    t.string   "file"
    t.string   "file_type"
    t.integer  "file_size",     :default => 0
    t.integer  "file_duration", :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "audio_profiles", ["audio_id"], :name => "index_audio_profiles_on_audio_id"

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "directories", :force => true do |t|
    t.integer  "account_id",                     :null => false
    t.string   "name",                           :null => false
    t.integer  "audios_count",    :default => 0
    t.integer  "articles_count",  :default => 0
    t.integer  "albums_count",    :default => 0
    t.integer  "kits_count",      :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "maps_count",      :default => 0
    t.integer  "merchants_count"
  end

  add_index "directories", ["account_id"], :name => "index_directories_on_account_id"

  create_table "guides", :force => true do |t|
    t.integer  "account_id",                          :null => false
    t.string   "name",                 :limit => 200, :null => false
    t.string   "qualificationscardno", :limit => 200
    t.text     "body"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "guides", ["account_id"], :name => "index_guides_on_account_id"
  add_index "guides", ["name"], :name => "index_guides_on_name"
  add_index "guides", ["qualificationscardno"], :name => "index_guides_on_qualificationscardno", :unique => true

  create_table "images", :force => true do |t|
    t.integer  "album_id",   :default => 0
    t.string   "title"
    t.string   "file"
    t.string   "file_type"
    t.integer  "file_size",  :default => 0
    t.integer  "order",      :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "images", ["album_id"], :name => "index_images_on_album_id"
  add_index "images", ["title"], :name => "index_images_on_title"

  create_table "kindeditor_assets", :force => true do |t|
    t.string   "asset"
    t.integer  "file_size"
    t.string   "file_type"
    t.integer  "owner_id"
    t.string   "asset_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "kit_profiles", :force => true do |t|
    t.integer  "kit_id",        :default => 0
    t.string   "file"
    t.string   "file_type"
    t.integer  "file_size",     :default => 0
    t.integer  "file_duration", :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "kit_profiles", ["kit_id"], :name => "index_kit_profiles_on_kit_id"

  create_table "map_profiles", :force => true do |t|
    t.integer  "map_id",     :default => 0
    t.string   "file"
    t.string   "file_type"
    t.integer  "file_size",  :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "map_profiles", ["map_id"], :name => "index_map_profiles_on_map_id"

  create_table "members", :force => true do |t|
    t.integer  "account_id",     :default => 0
    t.string   "open_id"
    t.string   "nickname"
    t.integer  "sex_cd",         :default => 0
    t.string   "city"
    t.string   "language"
    t.boolean  "subscribe",      :default => false
    t.datetime "last_reply_at"
    t.integer  "messages_count", :default => 0
    t.integer  "action_cd",      :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "members", ["account_id"], :name => "index_members_on_account_id"
  add_index "members", ["open_id"], :name => "index_members_on_open_id"

  create_table "menu_resources", :force => true do |t|
    t.integer  "menu_id",     :default => 0
    t.integer  "resource_id", :default => 0
    t.integer  "order",       :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "menu_resources", ["menu_id", "resource_id"], :name => "index_menu_resources_on_menu_id_and_resource_id"

  create_table "menus", :force => true do |t|
    t.integer  "account_id",           :default => 0
    t.integer  "parent_id",            :default => 0
    t.integer  "category_cd",          :default => 0
    t.string   "name"
    t.text     "body"
    t.string   "url"
    t.integer  "action_cd",            :default => 0
    t.integer  "order",                :default => 0
    t.boolean  "soft_delete",          :default => false
    t.boolean  "is_complete",          :default => false
    t.integer  "menu_resources_count", :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "menus", ["account_id"], :name => "index_menus_on_account_id"
  add_index "menus", ["parent_id"], :name => "index_menus_on_parent_id"

  create_table "merchant_images", :force => true do |t|
    t.integer  "merchant_id", :default => 0
    t.string   "title"
    t.string   "file"
    t.string   "file_type"
    t.integer  "file_size",   :default => 0
    t.integer  "order",       :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "merchant_images", ["merchant_id"], :name => "index_merchant_images_on_merchant_id"
  add_index "merchant_images", ["title"], :name => "index_merchant_images_on_title"

  create_table "merchant_profiles", :force => true do |t|
    t.integer  "merchant_id", :default => 0
    t.integer  "type_cd",     :default => 0
    t.string   "url"
    t.text     "body"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "member_id",   :default => 0
    t.text     "body"
    t.integer  "category_cd", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "messages", ["member_id"], :name => "index_messages_on_member_id"

  create_table "replies", :force => true do |t|
    t.integer  "account_id",            :default => 0
    t.integer  "parent_id",             :default => 0
    t.string   "number"
    t.string   "name"
    t.text     "body"
    t.integer  "category_cd",           :default => 0
    t.boolean  "is_system",             :default => false
    t.integer  "reply_resources_count", :default => 0
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.float    "lat"
    t.float    "lng"
    t.integer  "admin_user_id",         :default => 0
    t.integer  "scene_id",              :default => 0
    t.string   "ticket"
    t.boolean  "scene_delete",          :default => false
  end

  add_index "replies", ["account_id"], :name => "index_replies_on_account_id"
  add_index "replies", ["admin_user_id"], :name => "index_replies_on_admin_user_id"
  add_index "replies", ["lat"], :name => "index_replies_on_lat"
  add_index "replies", ["lng"], :name => "index_replies_on_lng"
  add_index "replies", ["name"], :name => "index_replies_on_name"
  add_index "replies", ["number"], :name => "index_replies_on_number"
  add_index "replies", ["parent_id"], :name => "index_replies_on_parent_id"
  add_index "replies", ["scene_id"], :name => "index_replies_on_scene_id"

  create_table "reply_resources", :force => true do |t|
    t.integer  "reply_id",    :default => 0
    t.integer  "resource_id", :default => 0
    t.integer  "order",       :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "reply_resources", ["reply_id", "resource_id"], :name => "index_reply_resources_on_reply_id_and_resource_id"

  create_table "resources", :force => true do |t|
    t.integer  "account_id",    :default => 0
    t.string   "type"
    t.string   "title"
    t.text     "description"
    t.string   "cover"
    t.string   "cover_type"
    t.integer  "cover_size"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "admin_user_id", :default => 0
  end

  add_index "resources", ["account_id"], :name => "index_resources_on_account_id"
  add_index "resources", ["admin_user_id"], :name => "index_resources_on_admin_user_id"
  add_index "resources", ["type"], :name => "index_resources_on_type"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "var",         :null => false
    t.text     "value"
    t.integer  "target_id",   :null => false
    t.string   "target_type", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "settings", ["target_type", "target_id", "var"], :name => "index_settings_on_target_type_and_target_id_and_var", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "votes", :force => true do |t|
    t.integer  "account_id",                :null => false
    t.string   "open_id",                   :null => false
    t.string   "booth",                     :null => false
    t.string   "phone",                     :null => false
    t.integer  "order",      :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "votes", ["account_id", "order"], :name => "index_votes_on_account_id_and_order", :unique => true
  add_index "votes", ["open_id"], :name => "index_votes_on_open_id"

  create_table "weathers", :force => true do |t|
    t.integer  "account_id",               :null => false
    t.string   "name",       :limit => 50, :null => false
    t.text     "body"
    t.datetime "weather_at"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "keyword",                  :null => false
  end

  add_index "weathers", ["account_id"], :name => "index_weathers_on_account_id"
  add_index "weathers", ["name"], :name => "index_weathers_on_name"

end
