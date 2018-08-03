require 'sinatra'
require 'httparty'
require 'json'
require_relative 'weather'
require_relative 'coffee'

class CoffeeAir < Sinatra::Base

  get '/' do
    content_type :json
    @weather = Weather.get_current
    @score = Weather.outdoor_desireability_score(@weather)
    @coffee = Coffee.find_coffee(@score['total'])
    @result = {'coffee'=> @coffee, 'air'=> @weather, 'weather_score'=> @score}
    @result.to_json
  end

end
