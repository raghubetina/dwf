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

ActiveRecord::Schema.define(:version => 20111213204759) do

  create_table "invitations", :force => true do |t|
    t.integer  "proposal_id"
    t.string   "facebook_user_id"
    t.string   "rsvp",                :default => "Maybe"
    t.string   "facebook_request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.integer  "deal_id"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "postal_code"
    t.string   "country"
    t.string   "lat"
    t.string   "lng"
    t.string   "phone_number"
    t.string   "state"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposals", :force => true do |t|
    t.integer  "user_id"
    t.string   "groupon_id"
    t.string   "announcement_title"
    t.datetime "proposed_datetime"
    t.integer  "min_companions"
    t.integer  "max_companions"
    t.integer  "tipped"
    t.string   "facebook_event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "facebook_user_id"
    t.string   "facebook_access_token"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location_id"
    t.string   "location_name"
    t.string   "gender"
    t.string   "timezone"
    t.string   "updated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
