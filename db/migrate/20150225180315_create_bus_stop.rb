class CreateBusStop < ActiveRecord::Migration
  def change
    create_table :bus_stops do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :address
    end
  end
end
