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

ActiveRecord::Schema.define(version: 20140328041731) do

  create_table "airports", force: true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "country"
    t.string   "state"
    t.string   "dot_id",          limit: 6
    t.string   "iata",            limit: 3
    t.decimal  "latitude",                  precision: 10, scale: 6
    t.decimal  "longitude",                 precision: 10, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_market_id"
    t.integer  "city_market_wac"
    t.date     "start_date"
    t.date     "thru_date"
    t.boolean  "closed"
  end

  add_index "airports", ["country"], name: "index_airports_on_country", using: :btree
  add_index "airports", ["dot_id"], name: "index_airports_on_dot_id", using: :btree
  add_index "airports", ["iata"], name: "index_airports_on_iata", using: :btree

  create_table "carriers", force: true do |t|
    t.string   "name"
    t.string   "code",       limit: 7
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "region",     limit: 100
    t.date     "start_date"
    t.date     "thru_date"
  end

  add_index "carriers", ["code"], name: "index_carriers_on_code", using: :btree
  add_index "carriers", ["slug"], name: "index_carriers_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

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
    t.string   "unique_carrier_code",   limit: 7
    t.string   "origin_airport_dot_id", limit: 6
    t.string   "dest_airport_dot_id",   limit: 6
    t.string   "aircraft_type_id"
    t.integer  "aircraft_group"
    t.integer  "aircraft_config"
    t.integer  "year"
    t.integer  "month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monthly_carrier_routes", ["dest_airport_dot_id"], name: "index_monthly_carrier_routes_on_dest_airport_dot_id", using: :btree
  add_index "monthly_carrier_routes", ["origin_airport_dot_id"], name: "index_monthly_carrier_routes_on_origin_airport_dot_id", using: :btree
  add_index "monthly_carrier_routes", ["unique_carrier_code", "origin_airport_dot_id", "dest_airport_dot_id"], name: "index_routes_on_airport_and_carrier_codes", using: :btree

end
