# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'csv'


puts "Loading airports..."
airports_fname = Rails.root.join('lib/assets/data/aggs/bts-t100-airports-by-record-passengers--post-2004.csv')
CSV.open(airports_fname, headers: true).each do |row|
  hsh = {
    name: row['description'].split(':')[-1].strip,
    iata: row['origin_airport_iata'],
    dot_id: row['origin_airport_dot_id'],
    latitude: row['latitude'],
    longitude: row['longitude'],
    country: row['iso_country'],
    city: row['municipality'],
    region: row['iso_region'],
    facility_type: row['airport_type']
  }


  a = Airport.create(hsh)
  puts "#{a.name} - #{[a.city, a.region, a.country].compact.join(', ')}"
end


puts "Loading carriers"
carriers_fname = Rails.root.join('lib/assets/data/aggs/bts-t100-carriers-by-record-passenger-count--post-2004.csv')
CSV.open(carriers_fname, headers: true).each do |row|
  c = Carrier.create(
    name: row['unique_carrier_name'],

    code: row['unique_carrier_code']
  )
  puts "Carrier: #{c.name}"
end

puts "\n\n\n\n\n", '----------------------------------'
puts "Now run:",
  "rake import:t100:sample:big",
  "rake import:t100:sample:prune"

