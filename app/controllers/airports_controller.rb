class AirportsController < ApplicationController
  def show
    @airport = Airport.find params[:id]
    @carriers = Carrier.all
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
