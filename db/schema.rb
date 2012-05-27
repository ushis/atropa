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

ActiveRecord::Schema.define(:version => 3) do

  create_table "tags", :force => true do |t|
    t.string "tag",  :null => false
    t.string "slug", :null => false
  end

  create_table "tags_videos", :id => false, :force => true do |t|
    t.integer "tag_id",   :null => false
    t.integer "video_id", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",        :null => false
    t.string   "password_digest", :null => false
    t.string   "email",           :null => false
    t.string   "login_hash"
    t.datetime "created_at",      :null => false
    t.string   "api_key"
    t.string   "gravatar_id"
  end

  create_table "videos", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "vid",        :null => false
    t.string   "title",      :null => false
    t.string   "slug",       :null => false
    t.integer  "width",      :null => false
    t.integer  "height",     :null => false
    t.string   "preview",    :null => false
    t.string   "provider",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
