class AirportsController < ApplicationController
  def show
    @airport = Airport.find params[:id]
    @carriers = @airport.serving_carriers
    @destinations = @airport.destinations

    @international_destinations = @airport.international_destinations
    @domestic_destinations = @airport.domestic_destinations

    # code smell: move this to model/helper
    @international_destination_route_paths = @international_destinations.map{ |dest|
        {
          origin: { latitude: @airport.latitude, longitude: @airport.longitude } ,
          destination:{ latitude: dest.latitude, longitude: dest.longitude }
        }
    }


    @domestic_destination_route_paths = @domestic_destinations.map{ |dest|
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
    @destinations = @airport.destinations_with_carrier(@carrier)
    @destination_route_paths = @destinations.map{ |dest|
        {
          origin: { latitude: @airport.latitude, longitude: @airport.longitude } ,
          destination:{ latitude: dest.latitude, longitude: dest.longitude }
        }
    }

  end


  def destination
    @origin = Airport.find params[:origin_id]
    @destination = Airport.find params[:destination_id]

    @routes = @origin.departing_routes.arriving_at(@destination).includes(:carrier).normal_order
  end

end
