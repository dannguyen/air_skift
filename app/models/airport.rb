class Airport < ActiveRecord::Base
  include ImportConcerns::BtsAirports
  include RouteAggregator

  extend FriendlyId
  friendly_id :iata, :use => [:finders]

  validates :dot_id, :uniqueness => true, :presence => true

  has_many :arriving_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_id', foreign_key: 'dest_airport_dot_id'
  has_many :departing_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_id', foreign_key: 'origin_airport_dot_id'

  # has_many :serving_carriers, ->{ uniq },  :through => :departing_monthly_carrier_routes , class_name: "Carrier", source: 'carrier'

# todo, refactor
  scope :with_total_passengers, ->{ joins(:departing_monthly_carrier_routes).
                        select('airports.*, sum(monthly_carrier_routes.passengers) AS total_passengers').
                        group('airports.id')  }

  scope :busiest, ->{ with_total_passengers.order('total_passengers DESC') }


  # TODO: Dry up with both Airport and Carrier methods
  alias_method :routes, :departing_monthly_carrier_routes

  alias_method :arriving_routes, :arriving_monthly_carrier_routes
  alias_method :departing_routes, :departing_monthly_carrier_routes


  # wow this is a doozy!
  def destinations # TK: refactor
    Airport.joins(:departing_monthly_carrier_routes).
    joins('INNER JOIN airports AS destination_airports ON
      destination_airports.dot_id =  monthly_carrier_routes.dest_airport_dot_id').
    where('monthly_carrier_routes.origin_airport_dot_id' => self.dot_id).
    select('destination_airports.*').
    agg_capacity.
    group("monthly_carrier_routes.dest_airport_dot_id").
    order('total_passengers DESC')
  end




  def location
    [city, state, country].compact.join(', ')
  end




  def serving_carriers # TK: refactor
    Carrier.joins(:monthly_carrier_routes => :origin_airport).
    where({:airports => {id: self.id}}).select('carriers.*').
    agg_capacity.
    group("monthly_carrier_routes.unique_carrier_code").
    order('total_passengers DESC')
  end



  # ugh, refactor this
  def self.find_by_uid(obj)
    uid = self.get_uid(obj)
    return uid.is_a?(Airport) ? uid : Airport.where(dot_id: uid).first
  end


  def self.with_route_sums # TK should refactor with RouteAggregator.route_sums
    self.joins(:departing_monthly_carrier_routes).
      select('airports.*').
      agg_capacity.
      group("monthly_carrier_routes.origin_airport_dot_id").
      order('total_passengers DESC')
  end


  # obj can either be a:
  # - Airport object
  # - iata, e.g. "LAX"
  # - numerical Rails :id
  # - :dot_id, e.g. "10002"

  # returns (for now): dot_id
  def self.get_uid(obj)
    return case obj
    when Airport
      obj.dot_id
    when /^[A-Z]{3}$/ # e.g. "JFK"
      Airport.where(iata: obj).pluck(:dot_id).first
    when Fixnum # assume it is numerical ID
      Airport.find(obj).dot_id
    else # actual :dot_id, e.g. "10345", which is a String
      obj
    end
  end
end
