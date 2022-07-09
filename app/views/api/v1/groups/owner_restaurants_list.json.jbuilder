json.extract! @group, :name, :address, :radius
json.members @group.members.length
json.member_allergies @group.members do |member|
    if member.allergies.present?
        json.name member.name
        json.allergy member.allergies
    end
end
json.restaurants @restaurants do |restaurant|
    json.extract! restaurant, :name, :address, :google_rating, :distance_in_km, :cached_weighted_score
end