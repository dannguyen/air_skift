class MainController < ApplicationController
  def index
    @carriers = Carrier.busiest.limit(20)
    @airports = Airport.busiest.limit(20)

  end
end
