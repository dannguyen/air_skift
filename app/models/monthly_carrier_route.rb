class MonthlyCarrierRoute < ActiveRecord::Base
  belongs_to :origin_airport, primary_key: 'dot_code', foreign_key: 'origin_airport_dot_code', class_name: 'Airport'
  belongs_to :destination_airport, primary_key: 'dot_code', foreign_key: 'dest_airport_dot_code', class_name: 'Airport'
  belongs_to :carrier, primary_key: 'code', foreign_key: 'unique_carrier_code'

  validates :unique_carrier_code, uniqueness: { scope: [:origin_airport_dot_code, :dest_airport_dot_code, :aircraft_type_id, :aircraft_config, :year, :month] }


  delegate :name, :to => :origin_airport, prefix: true
  delegate :name, :to => :destination_airport, prefix: true
  # TKS - Demeter of carrier name

  def name
    "#{carrier.name}: #{path_name}"
  end

  def path_name
    "#{origin_airport_name} => #{destination_airport_name}"
  end


  def self.build_from_official_csv(row)
    self.new(make_hash_from_official_csv(row))
  end

  # row is a CSV::Row
  def self.make_hash_from_official_csv(row)

    hsh = {}
    caseatts = %w(departures_scheduled departures_performed payload seats passengers freight mail distance ramp_to_ramp air_time aircraft_group aircraft_config year month)
    hsh = caseatts.inject({}) do |h, att|
      h[att.downcase] = row[att.upcase]

      h
    end

    hsh["unique_carrier_code"] = row['UNIQUE_CARRIER']
    hsh["origin_airport_dot_code"] = row['ORIGIN_AIRPORT_ID']
    hsh["dest_airport_dot_code"] = row['DEST_AIRPORT_ID']
    hsh["aircraft_type_id"] = row['AIRCRAFT_TYPE']

    return hsh
  end
end
