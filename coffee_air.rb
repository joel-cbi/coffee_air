require 'sinatra'
require 'sinatra/contrib'
require 'httparty'
require_relative 'weather'
require_relative 'coffee'

get '/' do
  @weather = Weather.get_current
  @weather.to_s
end
