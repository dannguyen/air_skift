class CarriersController < ApplicationController
  def show
    @carrier = Carrier.find params[:id]
  end


  def index
    @carriers = Carrier.all
  end
end
