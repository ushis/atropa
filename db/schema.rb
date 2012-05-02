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

ActiveRecord::Schema.define(:version => 1) do

  create_table "tags", :force => true do |t|
    t.string "tag"
    t.string "slug"
  end

  create_table "tags_videos", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "video_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.string   "login_hash"
    t.datetime "created_at"
  end

  create_table "videos", :force => true do |t|
    t.integer  "user_id"
    t.string   "vid"
    t.string   "title"
    t.string   "slug"
    t.integer  "width"
    t.integer  "height"
    t.string   "preview"
    t.string   "provider"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
