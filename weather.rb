class Weather
  include HTTParty

  def self.get_current
    weather = self.parse_response(self.request_weather_data)
  end

  def self.convert_temperature(kelvin)
    celsius = kelvin - 272.15
    farenheit = (celsius * 9 / 5) + 32
    { celsius: celsius.round(1), farenheit: farenheit.round(1) }
  end

  def self.parse_response(weather_data)
    puts weather_data
    weather = {}
    weather[:main] = weather_data[:weather][0][:main]
    weather[:description] = weather_data[:weather][0][:description]
    weather[:code] = weather_data[:weather][0][:id]
    weather[:temp] = self.convert_temperature(weather_data[:main][:temp])
    weather[:max_temp] = self.convert_temperature(weather_data[:main][:temp_max])
    weather[:min_temp] = self.convert_temperature(weather_data[:main][:temp_min])
    weather[:humidity] = self.convert_temperature(weather_data[:main][:humidity])
    weather[:wind_speed] = weather_data[:wind][:speed]
    weather[:wind_gusts] = weather_data[:wind][:gust]
    weather[:clouds] = weather_data[:clouds][:all]
    weather
  end

  def self.request_weather_data
    weather_response = self.get('http://api.openweathermap.org/data/2.5/weather?zip=10018,us&APPID=ad9a932a564f331879ce6e7de9750beb')
    JSON.parse(weather_response.body, {symbolize_names: true})
  end

  def self.outdoor_desireability_score(weather)
    types = [great: 2.0, nice: 1.0, tolerable: 0.0, bad: -1.0, horrible: -2.0]
    score = 0.0
    scores = [conditions: 0.0, temperature: 0.0, wind: 0.0]
    temps [:cold, :cool, :warm, :hot]

    case weather.code
    when 200..299
      scores[:conditions] + types[:horrible]
    when 300..399

    # when
    end

  end

  def weather_codes
    {
      # Thunderstorms
      200: 'thunderstorm with light rain',
      201: 'thunderstorm with rain',
      202: 'thunderstorm with heavy rain',
      210: 'light thunderstorm',
      211: 'thunderstorm',
      212: 'heavy thunderstorm',
      221: 'ragged thunderstorm',
      230: 'thunderstorm with light drizzle',
      231: 'thunderstorm with drizzle',
      232: 'thunderstorm with heavy drizzle',
      # Drizzles
      300: 'light intensity drizzle',
      301: 'drizzle',
      302: 'heavy intensity drizzle',
      310: 'light intensity drizzle rain',
      311: 'drizzle rain',
      312: 'heavy intensity drizzle rain',
      313: 'shower rain and drizzle',
      314: 'heavy shower rain and drizzle',
      321: 'shower drizzle',
      # Rain
      500: 'light rain',
      501: 'moderate rain',
      502: 'heavy intensity rain',
      503: 'very heavy rain',
      504: 'extreme rain',
      511: 'freezing rain',
      520: 'light intensity shower rain',
      521: 'shower rain',
      522: 'heavy intensity shower rain',
      531: 'ragged shower rain',
      # Snow
      600: 'light snow',
      601: 'snow',
      602: 'heavy snow',
      611: 'sleet',
      612: 'shower sleet',
      615: 'light rain and snow',
      616: 'rain and snow',
      620: 'light shower snow',
      621: 'shower snow',
      622: 'heavy shower snow',
      # Atmosphere
      701: 'mist',
      711: 'smoke',
      721: 'haze',
      731: 'sand, dust whirls',
      741: 'fog',
      751: 'sand',
      761: 'dust',
      762: 'volcanic ash',
      771: 'squalls',
      781: 'tornado',
      # Clear
      800: 'clear sky',
      # Clouds
      801: 'few clouds',
      802: 'scattered clouds',
      803: 'broken clouds',
      804: 'overcast clouds',
    }
  end

end
