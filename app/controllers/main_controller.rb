class MainController < ApplicationController
  def index
    @carriers = Carrier.all
  end
end
