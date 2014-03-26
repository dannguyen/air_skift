class Airport < ActiveRecord::Base

  validates :dot_code, :uniqueness => true, :presence => true

  has_many :arriving_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_code', foreign_key: 'dest_airport_dot_code'
  has_many :departing_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_code', foreign_key: 'origin_airport_dot_code'

  scope :with_total_passengers, ->{ joins(:departing_monthly_carrier_routes).
                        select('airports.*, sum(monthly_carrier_routes.passengers) AS total_passengers').
                        group('origin_airport_dot_code')  }

  scope :busiest, ->{ with_total_passengers.order('total_passengers DESC') }

  # scope :busiest, ->{ includes(:departing_monthly_carrier_routes).group(:origin_airport_dot_code).select("SUM(monthly_carrier_routes.passengers) as passengers_sum, airports.*")

  def location
    [city, state, country].compact.join(', ')
  end
end
