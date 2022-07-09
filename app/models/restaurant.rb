class Restaurant < ApplicationRecord
  acts_as_votable
  belongs_to :group
  validates :name, :address, :lat, :lng, :google_rating, :google_place_id, presence: true
end
