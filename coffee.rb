class Coffee
  include HTTParty
  API_KEY = 'AIzaSyDAH-Yf7QHL0hcWlElZETCp633HDYD7IvM'
  CBI_LAT_LONG = '40.752765,-73.989662'

  def self.find_coffee(score)
    radius = self.compute_max_radius(score).to_i
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{CBI_LAT_LONG}&radius=#{radius}&keyword=coffee&key=#{API_KEY}"
    response = self.get(url)
    self.parse_response(response['results'])
  end

  def self.parse_response(response)
    highly_rated_shops = response.select { |shop| shop['rating'] > 3.5 }
    random_index = Random.rand(highly_rated_shops.length)
    coffee_shop_data = highly_rated_shops[random_index]
    coffee_shop = {}
    coffee_shop['name'] = coffee_shop_data['name']
    coffee_shop['vicinity'] = coffee_shop_data['vicinity']
    coffee_shop['rating'] = coffee_shop_data['rating']
    return coffee_shop || 'Looks like NYC is all out of coffee!'
  end

  def self.compute_max_radius(score)
    min_radius = 100
    max_radius = min_radius * score
    return max_radius > min_radius ? max_radius : min_radius
  end

end
