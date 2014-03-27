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

    @routes = MonthlyCarrierRoute.alphabetical_carrier.chrono.where(:origin_airport_dot_id => @origin.dot_id).where(:dest_airport_dot_id => @destination.dot_id)
  end

end
