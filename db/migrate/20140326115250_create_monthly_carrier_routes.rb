class CreateMonthlyCarrierRoutes < ActiveRecord::Migration
  def change
    create_table :monthly_carrier_routes do |t|
      t.integer :departures_scheduled
      t.integer :departures_performed
      t.integer :payload
      t.integer :seats
      t.integer :passengers
      t.integer :freight
      t.integer :mail
      t.integer :distance
      t.integer :ramp_to_ramp
      t.integer :air_time
      t.string :unique_carrier_code
      t.string :origin_airport_dot_code
      t.string :dest_airport_dot_code
      t.string :aircraft_type_id
      t.integer :aircraft_group
      t.integer :aircraft_config
      t.integer :year
      t.integer :month

      t.timestamps
    end

    add_index :monthly_carrier_routes, [:unique_carrier_code, :origin_airport_dot_code, :dest_airport_dot_code], name: 'index_routes_on_airport_and_carrier_codes'
    add_index :monthly_carrier_routes, :origin_airport_dot_code
    add_index :monthly_carrier_routes, :dest_airport_dot_code

  end
end
