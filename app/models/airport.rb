class Airport < ActiveRecord::Base
  include ImportConcerns::BtsAirports
  extend FriendlyId
  friendly_id :iata, :use => [:finders]

  validates :dot_id, :uniqueness => true, :presence => true

  has_many :arriving_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_id', foreign_key: 'dest_airport_dot_id'
  has_many :departing_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_id', foreign_key: 'origin_airport_dot_id'

  has_many :serving_carriers, ->{ uniq },  :through => :departing_monthly_carrier_routes , class_name: "Carrier", source: 'carrier'

# todo, refactor
  scope :with_total_passengers, ->{ joins(:departing_monthly_carrier_routes).
                        select('airports.*, sum(monthly_carrier_routes.passengers) AS total_passengers').
                        group('airports.id')  }

  scope :busiest, ->{ with_total_passengers.order('total_passengers DESC') }


  # TODO: Dry up with both Airport and Carrier methods
  alias_method :routes, :departing_monthly_carrier_routes

  def destination_routes
    routes.destinations
  end

  alias_method :arriving_routes, :arriving_monthly_carrier_routes
  alias_method :departing_routes, :departing_monthly_carrier_routes

  def carriers_with_totals
# TK    departing_routes.total_capacity.group_by
  end


  def location
    [city, region, country].compact.join(', ')
  end




  # ugh, refactor this
  def self.find_by_uid(obj)
    uid = self.get_uid(obj)
    return uid.is_a?(Airport) ? uid : Airport.where(dot_id: uid).first
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
