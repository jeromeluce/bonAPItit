class BuildGroupRestaurantsList < ApplicationJob
    queue_as :default
  
    def perform(group)
        restaurants = get_top_20_restaurants(group.latlng, group.radius)
        grouplat = group.latlng.split(",")[0].to_f
        grouplng = group.latlng.split(",")[1].to_f
        restaurants["results"].each do |restaurant|
            Restaurant.create(
                name: restaurant["name"],
                address: restaurant["vicinity"],
                lat: restaurant["geometry"]["location"]["lat"],
                lng: restaurant["geometry"]["location"]["lng"],
                distance_in_km: Geocoder::Calculations.distance_between([grouplat, grouplng], [restaurant["geometry"]["location"]["lat"].to_f, restaurant["geometry"]["location"]["lng"].to_f], { units: :km }),
                google_rating: restaurant["rating"],
                google_place_id: restaurant["place_id"],
                group_id: group.id
            )
            
        end
    end

    private 

    def get_top_20_restaurants(latlng, radius)
        response = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=restaurant&language=fr&location=#{latlng}&radius=#{radius}&key=#{ENV['GOOGLE_PLACES_API_KEY']}")
        list = JSON.parse response.body 
    end
  end