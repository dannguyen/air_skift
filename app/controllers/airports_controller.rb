class AirportsController < ApplicationController
  def show
    @airport = Airport.find params[:id]
    @carriers = @airport.serving_carriers
    @destinations = @airport.destinations

    # code smell: move this to model/helper
    @destination_route_paths = @destinations.map{ |dest|
        {
          origin: { latitude: @airport.latitude, longitude: @airport.longitude } ,
          destination:{ latitude: dest.latitude, longitude: dest.longitude }
        }
    }
  end

  def index
    @airports = Airport.with_route_sums
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
