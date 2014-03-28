class Airport < ActiveRecord::Base

  extend FriendlyId
  friendly_id :iata, :use => [:finders]

  validates :dot_id, :uniqueness => true, :presence => true

  has_many :arriving_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_id', foreign_key: 'dest_airport_dot_id'
  has_many :departing_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_id', foreign_key: 'origin_airport_dot_id'

# todo, refactor
  scope :with_total_passengers, ->{ joins(:departing_monthly_carrier_routes).
                        select('airports.*, sum(monthly_carrier_routes.passengers) AS total_passengers').
                        group('airports.id')  }

  scope :busiest, ->{ with_total_passengers.order('total_passengers DESC') }

  # scope :busiest, ->{ includes(:departing_monthly_carrier_routes).group(:origin_airport_dot_id).select("SUM(monthly_carrier_routes.passengers) as passengers_sum, airports.*")



  def location
    [city, region, country].compact.join(', ')
  end



  def arriving_routes
    arriving_monthly_carrier_routes
  end

  def departing_routes
    departing_monthly_carrier_routes
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
