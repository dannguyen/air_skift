module RouteAggregator
  extend ActiveSupport::Concern

  included do
    scope :agg_passengers, -> { select('sum(monthly_carrier_routes.passengers) AS total_passengers') }
    scope :agg_departures_scheduled, ->{ select('sum(monthly_carrier_routes.departures_scheduled) AS total_departures_scheduled') }
    scope :agg_departures_performed, ->{ select('sum(monthly_carrier_routes.departures_performed) AS total_departures_performed') }
    scope :agg_seats, ->{ select('sum(monthly_carrier_routes.seats) AS total_seats') }

    scope :agg_capacity, ->{  agg_passengers.agg_departures_scheduled.agg_departures_performed.agg_seats}
  end


  # returns Hash of aggregations

  def route_sum_agged(s)
    route_sums(s).first
  end

  def route_sums(scoped_routes=nil)
    r = scoped_routes || self.routes

    r.agg_capacity# TK should be grouped by the unique_id of the relation
  end

  private
      def sql_id
        "#{self.class.table_name}.id"
      end

end


