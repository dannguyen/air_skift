# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'csv'


puts "Loading airports..."
airports_fname = Rails.root.join('lib/assets/data/lookups/L_AIRPORT_ID.csv')
CSV.open(airports_fname, headers: true).each do |row|
  hsh = {dot_code: row['Code']}
  location, hsh[:name] = row['Description'].split(': ')
  if location =~ /[A-Z]{2}$/ # i.e. a U.S. state
    hsh[:city], hsh[:state] = location.split(', ')
    hsh[:country] = 'U.S.'
  else
    hsh[:city], hsh[:country] = location.split(', ')
  end

  a = Airport.create(hsh)
  puts "#{a.name} - #{[a.city, a.state, a.country].compact.join(', ')}"
end


puts "Loading carriers"
carriers_fname = Rails.root.join('lib/assets/data/lookups/L_UNIQUE_CARRIERS.csv')
CSV.open(carriers_fname, headers: true).each do |row|
  c = Carrier.create(code: row['Code'], name: row['Description'])
  puts c.name
end
