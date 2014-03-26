require 'csv'

namespace :import do
  task :t100, [:filename] => [:environment] do |t, args|
    fname = Rails.root.join('lib/assets/data/t100', args.filename)

    CSV.open(fname, headers: true).each_slice(1000).each_with_index do |rows, idx|
      MonthlyCarrierRoute.import( rows.map{ |row|
        MonthlyCarrierRoute.build_from_official_csv(row)
      })

      puts "Imported slice #{idx}"
    end
  end


  task :sample_t100 => :environment do
    Rake::Task['import:t100'].invoke('sample/t_100.csv')
  end
end
