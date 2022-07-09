class Group < ApplicationRecord
    before_create :generate_codes, :geocode
    has_many :members
    has_many :restaurants
    validates :name, :address, :radius, presence: true
    validates :radius, numericality: { only_integer: true, greater_than: 999, less_than: 50001 }
    
    def geocode
        res = HTTParty.get("https://api.mapbox.com/geocoding/v5/mapbox.places/#{self.address.parameterize(separator: "%20")}.json?access_token=#{ENV['MAPBOX_API_KEY']}&country=FR")
        list = JSON.parse res.body
        coordinates = list["features"][0]["center"]
        self.latlng = coordinates.reverse.join(",")
        self.address_visualization = "http://www.google.com/maps/place/#{self.latlng}"
    end

    private

    def generate_codes
        self.registration_code = generate_registration_code
        self.admin_code = generate_admin_code(self.registration_code)
    end

    def generate_registration_code
        loop do 
            registration_code = SecureRandom.hex(3)
            break registration_code unless Group.where(registration_code: registration_code).exists?
        end
    end

    def generate_admin_code(registration_code)
        loop do 
            admin_code = registration_code + SecureRandom.hex(3)
            break admin_code unless Group.where(registration_code: admin_code).exists?
        end
    end

end
