class AddCurrentlyInRadiusToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :currently_in_radius, :boolean, default: true
  end
end
