require 'csv'

namespace :import do
  task :t100, [:filename] => [:environment] do |t, args|
    CSV.open(args.filename, headers: true).each do |row|
      h = MonthlyCarrierRoute.make_hash_from_official_csv(row)
      m = MonthlyCarrierRoute.create(h)

      puts "#{m.carrier.name}: #{m.origin_airport.name} => #{m.destination_airport.name}"
    end
  end


  task :sample_t100 => :environment do
    Rake::Task['import:t100'].invoke(Rails.root.join('lib/assets/data/sample/t_100.csv').to_s)
  end
end
