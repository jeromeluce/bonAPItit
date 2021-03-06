class BuildGroupRestaurantsListJob < ApplicationJob
    queue_as :default
  
    def perform(group)
        all_group_restaurants = Group.find(group.id).restaurants
        restaurants = get_top_20_restaurants(group.latlng, group.radius)
        grouplat = group.latlng.split(",")[0].to_f
        grouplng = group.latlng.split(",")[1].to_f
        if all_group_restaurants.length > 0
            all_group_restaurants.each do |restaurant|
                restaurant.currently_in_radius = false
                restaurant.save 
            end
            restaurants["results"].each do |restaurant|
                unless all_group_restaurants.find_by(google_place_id: restaurant["place_id"])&.update_attribute(:currently_in_radius, true)
                    Restaurant.create_from_google_data(restaurant, group.id, grouplat, grouplng)
                end
            end
        else
            restaurants["results"].each do |restaurant|
                Restaurant.create_from_google_data(restaurant, group.id, grouplat, grouplng)
                
            end
        end
    end

    private 

    def get_top_20_restaurants(latlng, radius)
        response = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=restaurant&language=fr&location=#{latlng}&radius=#{radius}&key=#{ENV['GOOGLE_PLACES_API_KEY']}")
        list = JSON.parse response.body 
    end
  end