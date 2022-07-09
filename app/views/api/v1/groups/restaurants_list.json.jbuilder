json.restaurants @restaurants do |restaurant|
    json.extract! restaurant, :name, :address, :google_rating, :distance_in_km
end