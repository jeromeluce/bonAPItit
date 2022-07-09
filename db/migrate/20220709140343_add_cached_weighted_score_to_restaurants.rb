class AddCachedWeightedScoreToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :cached_weighted_score, :integer
    Restaurant.find_each(&:update_cached_votes)
  end
end
