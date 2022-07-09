json.restaurants @restaurants do |restaurant|
    json.extract! restaurant, :id, :name, :address, :google_rating, :distance_in_km
end