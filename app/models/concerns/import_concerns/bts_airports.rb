module ImportConcerns
  module BtsAirports

    extend ActiveSupport::Concern
    ATT_MAP = {
      iata: :AIRPORT,
      dot_id: :AIRPORT_ID,
      name: :DISPLAY_AIRPORT_NAME,
      city: ->(r){ r['DISPLAY_AIRPORT_CITY_NAME_FULL'].split(', ')[0]},
      country: :AIRPORT_COUNTRY_NAME,
      state: :AIRPORT_STATE_CODE,
      city_market_id: :CITY_MARKET_ID,
      city_market_wac: :CITY_MARKET_WAC,
      latitude: :LATITUDE,
      longitude: :LONGITUDE,
      start_date: :AIRPORT_START_DATE,
      thru_date: :AIRPORT_THRU_DATE,
      closed: ->(r){ r['AIRPORT_IS_CLOSED'] == 0  }
    }

    # building from static data methods

    module ClassMethods
      def build_from_official_csv(row)
        self.new(make_hash_from_official_csv(row))
      end

      # row is a CSV::Row
      def make_hash_from_official_csv(row)

        hsh = ATT_MAP.inject({}) do |h, (k, v)|
          h[k] = v.is_a?(Symbol) ? row[v.to_s] : v.call(row)

          h
        end

        return hsh
      end
    end

  end
end

