class Airport < ActiveRecord::Base

  validates :dot_id, :uniqueness => true, :presence => true

  has_many :arriving_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_id', foreign_key: 'dest_airport_dot_id'
  has_many :departing_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_id', foreign_key: 'origin_airport_dot_id'

  scope :with_total_passengers, ->{ joins(:departing_monthly_carrier_routes).
                        select('airports.*, sum(monthly_carrier_routes.passengers) AS total_passengers').
                        group('origin_airport_dot_id')  }

  scope :busiest, ->{ with_total_passengers.order('total_passengers DESC') }

  # scope :busiest, ->{ includes(:departing_monthly_carrier_routes).group(:origin_airport_dot_id).select("SUM(monthly_carrier_routes.passengers) as passengers_sum, airports.*")

  def location
    [city, region, country].compact.join(', ')
  end
end
