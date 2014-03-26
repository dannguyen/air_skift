class Airport < ActiveRecord::Base

  validates :dot_code, :uniqueness => true, :presence => true

  has_many :arriving_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_code', foreign_key: 'dest_airport_dot_code'
  has_many :departing_monthly_carrier_routes, class_name: 'MonthlyCarrierRoute', primary_key: 'dot_code', foreign_key: 'origin_airport_dot_code'



  def location
    [city, state, country].compact.join(', ')
  end
end
