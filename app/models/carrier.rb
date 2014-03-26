class Carrier < ActiveRecord::Base
  validates :code, :uniqueness => true, :presence => true

  has_many :monthly_carrier_routes, primary_key: 'code', foreign_key: 'unique_carrier_code'
end
