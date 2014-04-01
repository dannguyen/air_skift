class CarriersController < ApplicationController
  def show
    @carrier = Carrier.find params[:id]
    @hubs = @carrier.hubs
  end


  def index
    @carriers = Carrier.with_route_sums
  end
end
