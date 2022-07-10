class Restaurant < ApplicationRecord
  acts_as_votable
  belongs_to :group
  validates :name, :address, :lat, :lng, :google_rating, :google_place_id, presence: true

  def self.create_from_google_data(restaurant, group_id, grouplat, grouplng)
    Restaurant.create(
      name: restaurant["name"],
      address: restaurant["vicinity"],
      lat: restaurant["geometry"]["location"]["lat"],
      lng: restaurant["geometry"]["location"]["lng"],
      distance_in_km: Geocoder::Calculations.distance_between([grouplat, grouplng], [restaurant["geometry"]["location"]["lat"].to_f, restaurant["geometry"]["location"]["lng"].to_f], { units: :km })&.round(3),
      google_rating: restaurant["rating"],
      google_place_id: restaurant["place_id"],
      group_id: group_id
    )
  end
end
