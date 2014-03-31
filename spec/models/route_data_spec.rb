require 'spec_helper'

describe 'RouteAgg' do

  describe '#facet', skip: true do

    before do
      @airport = create(:airport)
      create(:routes)
    end

    it 'should return Airport objects with capacity' do
      RouteAgg(@airport.routes).facet(:origin_airport_id, ->(a){Airport.find(a)})
    end



  end
end
