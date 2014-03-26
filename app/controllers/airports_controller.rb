class AirportsController < ApplicationController
  def show
    @airport = Airport.find params[:id]
  end


  def index
    @airports = Airport.all
  end
end
