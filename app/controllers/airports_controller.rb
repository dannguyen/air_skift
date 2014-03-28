class AirportsController < ApplicationController
  def show
    @airport = Airport.find_by_uid params[:id]
    @carriers = Carrier.all
  end


  def index
    @airports = Airport.all
  end


  def carrier
    @airport = Airport.find_by_uid params[:id]
    @carrier = Carrier.find_by_uid params[:carrier_id]
  end


  def destination
    @origin = Airport.find_by_uid params[:origin_id]
    @destination = Airport.find_by_uid params[:destination_id]

    @routes = @origin.departing_routes.arriving_at(@destination).includes(:carrier).normal_order
  end

end
