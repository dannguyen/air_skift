require 'csv'

namespace :import do
  namespace :t100 do
    task :file, [:filename] => [:environment] do |t, args|
      fname = Rails.root.join('lib/assets/data/t100', args.filename)

      CSV.open(fname, headers: true).each_slice(1000).each_with_index do |rows, idx|
        MonthlyCarrierRoute.import( rows.map{ |row|
          MonthlyCarrierRoute.build_from_official_csv(row)
        })

        puts "Imported slice #{idx}"
      end
    end


    namespace :sample do
      task :big => :environment do
        Rake::Task['import:t100:file'].invoke('t100-sample-top-airlines-2009-on.csv')
      end

      task :small => :environment do
        Rake::Task['import:t100:file'].invoke('sample/t_100.csv')
      end

      desc 'removes all airports and carriers not in the sample'
      task :prune => :environment do
        Airport.select { |a| a.departing_monthly_carrier_routes.size < 1 && a.arriving_monthly_carrier_routes.size < 1 }.each do |a|
          puts "Deleting airport #{a.name}"
          a.delete
        end

        Carrier.select { |a| a.monthly_carrier_routes.size < 1 }.each do |a|
          puts "Deleting carrier #{a.name}"
          a.delete
        end
      end
    end


  end
end
