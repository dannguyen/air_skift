require 'spec_helper'

describe Airport do

  describe 'validations' do
    it 'should have unique dot_id' do
      create(:airport)
      create(:airport)
      Airport.create(dot_id: Airport.first.dot_id)
      # just a sanity test
      expect(Airport.count).to eq 2
    end
  end
end
