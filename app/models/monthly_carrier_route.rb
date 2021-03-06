class MonthlyCarrierRoute < ActiveRecord::Base

  include ImportConcerns::T100Routes
  include RouteAggregator

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


  scope :busiest, ->{ order("total_passengers DESC") }

  scope :with_origin, ->{ includes(:origin_airport) }
  scope :with_destination, ->{ includes(:destination_airport) }

  scope :with_path, ->{ with_origin.with_destination }
  scope :with_specific_path, ->(a, b){ with_path.departing_from(a).arriving_at(b)   }
  scope :with_carrier, ->{ includes([:carrier]).select('carriers.*') }

  scope :group_by_origin, ->{ group("monthly_carrier_routes.origin_airport_dot_id").where("monthly_carrier_routes.origin_airport_dot_id IS NOT ?", nil) }
  scope :group_by_destination, ->{ group("monthly_carrier_routes.dest_airport_dot_id").where("monthly_carrier_routes.dest_airport_dot_id IS NOT ?", nil) }


  scope :destinations, ->{agg_capacity.with_destination.group_by_destination.order('total_passengers DESC').select('monthly_carrier_routes.*')}
  scope :hubs, -> { agg_capacity.with_origin.group_by_origin.order('total_passengers DESC').select('monthly_carrier_routes.*') }




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

  # returns a Hash: { 2012-02 => 30,500 }
  def self.group_passengers_by_date
    self.order('year ASC, month ASC').group([:year, :month]).sum('passengers')
  end


  def self.us_destination
    self.joins('INNER JOIN airports AS destination_airports ON destination_airports.dot_id = monthly_carrier_routes.dest_airport_dot_id').where('destination_airports.country = ?', 'United States')
  end

  def self.international_destination
    self.joins('INNER JOIN airports AS destination_airports ON destination_airports.dot_id = monthly_carrier_routes.dest_airport_dot_id').where('destination_airports.country != ?', 'United States')
  end



end