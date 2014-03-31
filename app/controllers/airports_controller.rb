class AirportsController < ApplicationController
  def show
    @airport = Airport.find params[:id]
    @carriers = @airport.serving_carriers
    @destination_routes = @airport.destination_routes.having("total_passengers > 10000")

    # code smell: move this to model/helper
    @destination_route_paths = @destination_routes.map{ |route|
        dest = route.destination_airport
        {
          origin: { latitude: @airport.latitude, longitude: @airport.longitude } ,
          destination:{ latitude: dest.latitude, longitude: dest.longitude }
        }
    }
  end

  def index
    @airports = Airport.all
  end


  def carrier
    @airport = Airport.find params[:id]
    @carrier = Carrier.find params[:carrier_id]
  end


  def destination
    @origin = Airport.find params[:origin_id]
    @destination = Airport.find params[:destination_id]

    @routes = @origin.departing_routes.arriving_at(@destination).includes(:carrier).normal_order
  end

end
