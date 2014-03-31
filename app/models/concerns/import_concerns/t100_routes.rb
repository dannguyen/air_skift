module ImportConcerns
  module T100Routes

    extend ActiveSupport::Concern


    # building from static data methods

    module ClassMethods
      def build_from_official_csv(row)
        self.new(make_hash_from_official_csv(row))
      end

      # row is a CSV::Row
      def make_hash_from_official_csv(row)

        hsh = {}
        caseatts = %w(departures_scheduled departures_performed payload seats passengers freight mail distance ramp_to_ramp air_time aircraft_group aircraft_config year month)
        hsh = caseatts.inject({}) do |h, att|
          h[att.downcase] = row[att.upcase]

          h
        end

        hsh["unique_carrier_code"] = row['UNIQUE_CARRIER']
        hsh["origin_airport_dot_id"] = row['ORIGIN_AIRPORT_ID']
        hsh["dest_airport_dot_id"] = row['DEST_AIRPORT_ID']
        hsh["aircraft_type_id"] = row['AIRCRAFT_TYPE']

        return hsh
      end
    end

  end
end
