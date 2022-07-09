class AddDefaultValueToRestaurantsCachedWeightedScore < ActiveRecord::Migration[6.1]
  def change
    change_column :restaurants, :cached_weighted_score, :integer, default: 0
  end
end
