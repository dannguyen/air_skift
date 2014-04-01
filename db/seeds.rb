# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'csv'


puts "Loading airports..."
airports_fname = Rails.root.join('lib/assets/data/bts_aviation_support/airports/airports.csv')
CSV.open(airports_fname, headers: true).each do |row|
  a = Airport.build_from_official_csv(row)
  a.save
  puts "#{a.name} - #{a.iata} #{[a.city, a.country].compact.join(', ')}"
end


puts "Loading carriers"
# TODO/TK: Properly use AIRLINE_ID instead of UNIQUE_CARRIER, and choose the latest record. Example :Horizon Air
carriers_fname = Rails.root.join('lib/assets/data/bts_aviation_support/carriers/carriers.csv')
CSV.open(carriers_fname, headers: true).each do |row|
  a = Carrier.build_from_official_csv(row)
  a.save

  puts "Carrier: #{a.name} #{a.code}"
end

puts "\n\n\n\n\n", '----------------------------------'
puts "Now run:",
  "rake import:t100:sample:big",
  "rake import:t100:sample:prune"

