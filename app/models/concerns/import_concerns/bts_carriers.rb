module ImportConcerns
  module BtsCarriers

    extend ActiveSupport::Concern
    ATT_MAP = {
      id: :AIRLINE_ID,
      code: :UNIQUE_CARRIER,
      name: :UNIQUE_CARRIER_NAME,
      region: :REGION,
      start_date: :START_DATE_SOURCE,
      thru_date: :THRU_DATE_SOURCE
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

