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

ActiveRecord::Schema.define(version: 20140326115302) do

  create_table "airports", force: true do |t|
    t.string   "name"
    t.string   "state"
    t.string   "country"
    t.string   "city"
    t.string   "dot_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "airports", ["dot_code"], name: "index_airports_on_dot_code", using: :btree

  create_table "carriers", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "carriers", ["code"], name: "index_carriers_on_code", using: :btree

  create_table "monthly_carrier_routes", force: true do |t|
    t.integer  "departures_scheduled"
    t.integer  "departures_performed"
    t.integer  "payload"
    t.integer  "seats"
    t.integer  "passengers"
    t.integer  "freight"
    t.integer  "mail"
    t.integer  "distance"
    t.integer  "ramp_to_ramp"
    t.integer  "air_time"
    t.string   "unique_carrier_code"
    t.string   "origin_airport_dot_code"
    t.string   "dest_airport_dot_code"
    t.string   "aircraft_type_id"
    t.integer  "aircraft_group"
    t.integer  "aircraft_config"
    t.integer  "year"
    t.integer  "month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monthly_carrier_routes", ["dest_airport_dot_code"], name: "index_monthly_carrier_routes_on_dest_airport_dot_code", using: :btree
  add_index "monthly_carrier_routes", ["origin_airport_dot_code"], name: "index_monthly_carrier_routes_on_origin_airport_dot_code", using: :btree
  add_index "monthly_carrier_routes", ["unique_carrier_code", "origin_airport_dot_code", "dest_airport_dot_code"], name: "index_routes_on_airport_and_carrier_codes", using: :btree

end
