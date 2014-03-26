class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :name
      t.string :state
      t.string :country
      t.string :city
      t.string :dot_code

      t.timestamps
    end
  end
end
