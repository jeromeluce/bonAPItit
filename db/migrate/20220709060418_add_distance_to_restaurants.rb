class AddDistanceToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :distance_in_km, :float
  end
end
