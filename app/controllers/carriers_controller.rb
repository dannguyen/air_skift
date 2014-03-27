class CarriersController < ApplicationController
  def show
    @carrier = Carrier.find params[:id]
    @hubs = @carrier.monthly_carrier_routes.group(:origin_airport_dot_id).includes(:origin_airport
      )
  end


  def index
    @carriers = Carrier.all
  end
end
