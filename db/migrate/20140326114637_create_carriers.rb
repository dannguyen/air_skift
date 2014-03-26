class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :name
      t.string :code

      t.timestamps
    end

    add_index :carriers, :code

  end
end
