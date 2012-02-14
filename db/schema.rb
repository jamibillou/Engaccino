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

ActiveRecord::Schema.define(:version => 20120213214901) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "phone"
    t.string   "email"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "degree_types", :force => true do |t|
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "degrees", :force => true do |t|
    t.string   "label"
    t.integer  "degree_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "degrees_schools", :id => false, :force => true do |t|
    t.integer "degree_id", :null => false
    t.integer "school_id", :null => false
  end

  create_table "educations", :force => true do |t|
    t.integer  "degree_id"
    t.integer  "school_id"
    t.integer  "candidate_id"
    t.string   "description"
    t.integer  "start_month"
    t.integer  "start_year"
    t.integer  "end_month"
    t.integer  "end_year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "main",         :default => false
  end

  create_table "experiences", :force => true do |t|
    t.integer  "candidate_id"
    t.integer  "company_id"
    t.integer  "start_month"
    t.integer  "start_year"
    t.integer  "end_month"
    t.integer  "end_year"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.boolean  "current",      :default => false
  end

  create_table "interpersonal_skill_candidates", :force => true do |t|
    t.string   "description"
    t.integer  "candidate_id"
    t.integer  "interpersonal_skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "language_candidates", :force => true do |t|
    t.integer  "language_id"
    t.integer  "candidate_id"
    t.enum     "level",        :limit => [:beginner, :intermediate, :fluent, :native]
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "professional_skill_candidates", :force => true do |t|
    t.string   "level"
    t.integer  "experience"
    t.string   "description"
    t.integer  "candidate_id"
    t.integer  "professional_skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.string   "label"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.string   "country"
    t.string   "nationality"
    t.integer  "year_of_birth"
    t.string   "phone"
    t.string   "email"
    t.string   "facebook_login"
    t.string   "linkedin_login"
    t.string   "twitter_login"
    t.string   "status"
    t.string   "type"
    t.boolean  "facebook_connect",   :default => false
    t.boolean  "linkedin_connect",   :default => false
    t.boolean  "twitter_connect",    :default => false
    t.integer  "profile_completion", :default => 0
    t.boolean  "admin",              :default => false
    t.string   "salt"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
