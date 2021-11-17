class YelpSearch

    attr_reader :response, :businesses

    def initialize(location)
        url = "https://api.yelp.com/v3/businesses/search"
        params = {
          term: "lunch",
          location: location,
          limit: 50
        }
        response = HTTP.auth("Bearer #{ENV["YELP_API_KEY"]}").get(url, params: params)
        @response = response.parse
        @businesses = @response["businesses"]
    end

    def to_restaurants

        self.businesses.map do |business|
            Restaurant.find_or_create_by(yelp_id: business["id"]) do |restaurant|
                restaurant.name = business["name"]
                restaurant.url = business["url"]
                restaurant.latitude = business["coordinates"]["latitude"]
                restaurant.longitude = business["coordinates"]["longitude"]
                restaurant.image_url = business["image_url"]
                restaurant.address = business["location"]["display_address"].join(", ")
                restaurant.zip_code = business["location"]["zip_code"].to_i
                restaurant.description = business["categories"].map{|hash| hash["title"]}.join(", ")
                restaurant.score = business["rating"]
                restaurant.phone = business["phone"]
            end
        end
    end
end