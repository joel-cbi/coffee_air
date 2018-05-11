class Weather
  include HTTParty

  def self.get_current
    weather = self.parse_response(self.request_weather_data)
  end

  def self.convert_temperature(kelvin)
    celsius = kelvin - 272.15
    farenheit = (celsius * 9 / 5) + 32
    { 'celsius' => celsius.round(1), 'farenheit' => farenheit.round(1) }
  end

  def self.parse_response(weather_data)
    weather = {}
    weather['main'] = weather_data['weather'][0]['main']
    weather['description'] = weather_data['weather'][0]['description']
    weather['code'] = weather_data['weather'][0]['id']
    weather['temp'] = self.convert_temperature(weather_data['main']['temp'])
    weather['max_temp'] = self.convert_temperature(weather_data['main']['temp_max'])
    weather['min_temp'] = self.convert_temperature(weather_data['main']['temp_min'])
    weather['humidity'] = weather_data['main']['humidity']
    weather['wind_speed'] = weather_data['wind']['speed']
    weather['wind_gusts'] = weather_data['wind']['gust']
    weather['clouds'] = weather_data['clouds']['all']
    weather
  end

  def self.request_weather_data
    weather_response = self.get('http://api.openweathermap.org/data/2.5/weather?zip=10018,us&APPID=ad9a932a564f331879ce6e7de9750beb')
    response = JSON.parse(weather_response.body)
  end

  def self.outdoor_desireability_score(weather)
    scores = { 'conditions'=> 0.0, 'temperature'=> 0.0, 'wind'=> 0.0 }
    scores['conditions'] = self.weather_codes(weather['code'].to_s)['score']
    scores['temperature'] = self.score_temperature(weather['temp'])
    scores['wind'] = self.score_wind(weather['wind_speed'], weather['wind_gusts'])
    scores['total'] = scores.values.reduce(:+)
    scores
  end

  def self.weather_codes(code=nil)
    codes = {}
    # Thunderstorms
    codes['200'] = { 'description'=> 'thunderstorm with light rain', 'score'=> -1.0 }
    codes['201'] = { 'description'=> 'thunderstorm with rain', 'score'=> -2.0 }
    codes['202'] = { 'description'=> 'thunderstorm with heavy rain', 'score'=> -3.0 }
    codes['210'] = { 'description'=> 'light thunderstorm', 'score'=> -1.0 }
    codes['211'] = { 'description'=> 'thunderstorm', 'score'=> -2.0 }
    codes['212'] = { 'description'=> 'heavy thunderstorm', 'score'=> -3.0 }
    codes['221'] = { 'description'=> 'ragged thunderstorm', 'score'=> -3.0 }
    codes['230'] = { 'description'=> 'thunderstorm with light drizzle', 'score'=> -1.0 }
    codes['231'] = { 'description'=> 'thunderstorm with drizzle', 'score'=> -1.0 }
    codes['232'] = { 'description'=> 'thunderstorm with heavy drizzle', 'score'=> -2.0 }
    # Drizzles
    codes['300'] = { 'description'=> 'light intensity drizzle', 'score'=> -0.0 }
    codes['301'] = { 'description'=> 'drizzle', 'score'=> -1.0 }
    codes['302'] = { 'description'=> 'heavy intensity drizzle', 'score'=> -1.0 }
    codes['310'] = { 'description'=> 'light intensity drizzle rain', 'score'=> -1.0 }
    codes['311'] = { 'description'=> 'drizzle rain', 'score'=> -1.0 }
    codes['312'] = { 'description'=> 'heavy intensity drizzle rain', 'score'=> -1.0 }
    codes['313'] = { 'description'=> 'shower rain and drizzle', 'score'=> -1.0 }
    codes['314'] = { 'description'=> 'heavy shower rain and drizzle', 'score'=> -2.0 }
    codes['321'] = { 'description'=> 'shower drizzle', 'score'=> -1.0 }
    # Rain
    codes['500'] = { 'description'=> 'light rain', 'score'=> -1.0 }
    codes['501'] = { 'description'=> 'moderate rain', 'score'=> -2.0 }
    codes['502'] = { 'description'=> 'heavy intensity rain', 'score'=> -2.0 }
    codes['503'] = { 'description'=> 'very heavy rain', 'score'=> -3.0 }
    codes['504'] = { 'description'=> 'extreme rain', 'score'=> -3.0 }
    codes['511'] = { 'description'=> 'freezing rain', 'score'=> -2.0 }
    codes['520'] = { 'description'=> 'light intensity shower rain', 'score'=> -1.0 }
    codes['521'] = { 'description'=> 'shower rain', 'score'=> -1.0 }
    codes['522'] = { 'description'=> 'heavy intensity shower rain', 'score'=> -2.0 }
    codes['531'] = { 'description'=> 'ragged shower rain', 'score'=> -2.0 }
    # Snow
    codes['600'] = { 'description'=> 'light snow', 'score'=> -1.0 }
    codes['601'] = { 'description'=> 'snow', 'score'=> -1.0 }
    codes['602'] = { 'description'=> 'heavy snow', 'score'=> -1.0 }
    codes['611'] = { 'description'=> 'sleet', 'score'=> -2.0 }
    codes['612'] = { 'description'=> 'shower sleet', 'score'=> -2.0 }
    codes['615'] = { 'description'=> 'light rain and snow', 'score'=> -1.0 }
    codes['616'] = { 'description'=> 'rain and snow', 'score'=> -2.0 }
    codes['620'] = { 'description'=> 'light shower snow', 'score'=> -1.0 }
    codes['621'] = { 'description'=> 'shower snow', 'score'=> -2.0 }
    codes['622'] = { 'description'=> 'heavy shower snow', 'score'=> -3.0 }
    # Atmosphere
    codes['701'] = { 'description'=> 'mist', 'score'=> -0.0 }
    codes['711'] = { 'description'=> 'smoke', 'score'=> -1.0 }
    codes['721'] = { 'description'=> 'haze', 'score'=> -0.0 }
    codes['731'] = { 'description'=> 'sand, dust whirls', 'score'=> -1.0 }
    codes['741'] = { 'description'=> 'fog', 'score'=> -0.0 }
    codes['751'] = { 'description'=> 'sand', 'score'=> -1.0 }
    codes['761'] = { 'description'=> 'dust', 'score'=> -1.0 }
    codes['762'] = { 'description'=> 'volcanic ash', 'score'=> -3.0 }
    codes['771'] = { 'description'=> 'squalls', 'score'=> -2.0 }
    codes['781'] = { 'description'=> 'tornado', 'score'=> -3.0 }
    # Clear
    codes['800'] = { 'description'=> 'clear sky', 'score'=> 3.0 }
    # Clouds
    codes['801'] = { 'description'=> 'few clouds', 'score'=> 3.0 }
    codes['802'] = { 'description'=> 'scattered clouds', 'score'=> 2.0 }
    codes['803'] = { 'description'=> 'broken clouds', 'score'=> 1.0 }
    codes['804'] = { 'description'=> 'overcast clouds', 'score'=> 0.0 }

    if code.nil?
      return codes
    else
      return codes[code]
    end
  end

  def self.score_temperature(temp)
    case temp['farenheit']
    when 70...80
      4.0
    when 60...70, 80...90
      3.0
    when 50...60
      2.0
    when 35...50, 90...100
      1.0
    else
      0.0
    end
  end

  def self.score_wind(wind_speed, wind_gusts)
    score = 0.0
    score += 1.0 if wind_speed < 15.0
    score -= 1.0 if wind_speed > 40.0
    score
  end

end
