module RouteAggregator
  extend ActiveSupport::Concern

  included do
    scope :agg_passengers, -> { select('sum(monthly_carrier_routes.passengers) AS total_passengers') }
    scope :agg_departures_scheduled, ->{ select('sum(monthly_carrier_routes.departures_scheduled) AS total_departures_scheduled') }
    scope :agg_departures_performed, ->{ select('sum(monthly_carrier_routes.departures_performed) AS total_departures_performed') }
    scope :agg_seats, ->{ select('sum(monthly_carrier_routes.seats) AS total_seats') }

    scope :agg_capacity, ->{  agg_passengers.agg_departures_scheduled.agg_departures_performed.agg_seats}
  end
end


