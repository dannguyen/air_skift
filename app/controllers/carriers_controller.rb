class CarriersController < ApplicationController
  def show
    @carrier = Carrier.find params[:id]
    # TODO: make the model fat, obviously
    @hubs = @carrier.hubs

    # @routes = @carrier.monthly_carrier_routes.total_capacity.with_origin.
    #   group('monthly_carrier_routes.origin_airport_dot_id, year, month ')
  end


  def index
    @carriers = Carrier.all
  end
end
