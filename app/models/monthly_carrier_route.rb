class MonthlyCarrierRoute < ActiveRecord::Base
  belongs_to :origin_airport, primary_key: 'dot_id', foreign_key: 'origin_airport_dot_id', class_name: 'Airport'
  belongs_to :destination_airport, primary_key: 'dot_id', foreign_key: 'dest_airport_dot_id', class_name: 'Airport'
  belongs_to :carrier, primary_key: 'code', foreign_key: 'unique_carrier_code'

  validates :unique_carrier_code, uniqueness: { scope: [:origin_airport_dot_id, :dest_airport_dot_id, :aircraft_type_id, :aircraft_config, :year, :month] }


  scope :chrono, ->{ order('year ASC, month ASC') }
  scope :alphabetical_path, ->{ order('origin_airport_dot_id ASC, dest_airport_dot_id ASC')}
  scope :alphabetical_carrier, ->{ order('unique_carrier_code ASC')}

  scope :normal_order, ->{ alphabetical_carrier.chrono }

  scope :in_year, ->(y){ where(year: y) }
  scope :in_month, ->(m){ where(month: m) }

  scope :leaving_from, ->(a){ where( :origin_airport_dot_id => Airport.get_uid(a))  }
  scope :departing_from, ->(a){ leaving_from(a) } # alias
  scope :arriving_at, ->(a){ where :dest_airport_dot_id => Airport.get_uid(a)  }
  scope :via, ->(c){ where :unique_carrier_code => Carrier.get_uid(c) }

  scope :total_passengers, -> { select('sum(monthly_carrier_routes.passengers) AS total_passengers') }
  scope :total_departures_scheduled, ->{ select('sum(monthly_carrier_routes.departures_scheduled) AS total_departures_scheduled') }
  scope :total_departures_performed, ->{ select('sum(monthly_carrier_routes.departures_performed) AS total_departures_performed') }
  scope :total_seats, ->{ select('sum(monthly_carrier_routes.seats) AS total_seats') }

  scope :total_capacity, ->{  total_passengers.total_departures_scheduled.total_departures_performed.total_seats.select('monthly_carrier_routes.*') }

  scope :busiest, ->{ order("total_passengers DESC") }

  scope :with_origin, ->{ includes(:origin_airport) }
  scope :with_destination, ->{ includes(:destination_airport) }

  scope :with_path, ->{ with_origin.with_destination }
  scope :with_specific_path, ->(a, b){ with_path.departing_from(a).arriving_at(b)   }
  scope :with_carrier, ->{ includes([:carrier]).select('carriers.*') }

  scope :group_by_origin, ->{ group("monthly_carrier_routes.origin_airport_dot_id") }
  scope :group_by_destination, ->{ group("monthly_carrier_routes.dest_airport_dot_id") }


  scope :destinations, ->{total_capacity.with_destination.group_by_destination.order('total_passengers DESC')}
  scope :hubs, -> { total_capacity.with_origin.group_by_origin.order('total_passengers DESC') }



  scope :no_passengers, ->{ where(passengers: 0)}


  delegate :name, :to => :origin_airport, prefix: true, allow_nil: true
  delegate :name, :to => :destination_airport, prefix: true, allow_nil: true
  delegate :name, :to => :carrier, prefix: true, allow_nil: true

  def name
    "#{carrier.name}: #{path_name}"
  end

  def path_name
    "#{origin_airport_name} => #{destination_airport_name}"
  end





  # building from static data methods

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
    hsh["origin_airport_dot_id"] = row['ORIGIN_AIRPORT_ID']
    hsh["dest_airport_dot_id"] = row['DEST_AIRPORT_ID']
    hsh["aircraft_type_id"] = row['AIRCRAFT_TYPE']

    return hsh
  end
end
