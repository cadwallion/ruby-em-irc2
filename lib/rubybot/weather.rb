require 'nokogiri'
class CadWeather
	WEATHER_PAR = "1079693758"
	WEATHER_API = "a6939d9b2b51255c"
	QUERY_PARAMS = {
			'cc' => '*',
			'link' => 'xoap',
			'prod' => 'xoap',
			'par' => WEATHER_PAR,
			'key' => WEATHER_API
	}
	def self.weather(params, event)
		case params[1]
		when "forecast"
			self.get_forecast(params[2], event)
		when "report"
			self.get_current(params[2], event)
		end
	end

	def self.get_current(code, event)
		EM.synchrony do
			http = EventMachine::HttpRequest.new("http://xoap.weather.com/weather/local/#{code}").get :query => QUERY_PARAMS
			http.callback {
				weather = Nokogiri::XML(http.response).root.xpath("/weather")
				if weather.xpath("//cc")
					event.connection.send_message(Rubybot::PluginSystem.get_target(event), "Location: #{weather.xpath('//loc/dnam').inner_text} - Updated at: #{weather.xpath('//cc/lsup').text}")
					current = "Temp: #{weather.xpath('//cc/tmp').text}F/#{CadWeather.convert_to_c(weather.xpath('//cc/tmp').text)}C - "
					current << "Feels like: #{weather.xpath("//cc/flik").text}F/#{CadWeather.convert_to_c(weather.xpath("//cc/flik").text)}C - "
					current << "Wind: #{weather.xpath("//cc/wind/t").text} #{weather.xpath("//cc/wind/s").text} MPH - "
					current << "Conditions: #{weather.xpath("//cc/t").text} - "
					current << "Humidity: #{weather.xpath("//cc/hmid").text}%"
					event.connection.send_message(Rubybot::PluginSystem.get_target(event), current)
				else
					event.connection.send_message(Rubybot::PluginSystem.get_target(event), "City code not found.")
				end
			}
		end
	end

	def self.get_forecast(code, event)
		EM.synchrony do
		puts code
		http = EventMachine::HttpRequest.new("http://xoap.weather.com/weather/local/#{code}").get :query => QUERY_PARAMS.merge('dayf' => '5')
		http.callback {
			weather = Nokogiri::XML(http.response).root.xpath("/weather")
			if weather.xpath('//dayf')
				event.connection.send_message(Rubybot::PluginSystem.get_target(event), "Location: #{weather.xpath('//loc/dnam').inner_text}")
				weather.xpath('//dayf/day').each do |day|
					forecast = "#{day['t']} #{day['dt']} - High: #{day.xpath('hi').text}F/#{CadWeather.convert_to_c(day.xpath('hi').text)}C"
					forecast << "# - Low: #{day.xpath('low').text}F/#{CadWeather.convert_to_c(day.xpath('low').text)}C"
					
					day.xpath('part').each do |part|
						if part['p'] == "n"
							forecast << " - Night: #{part.xpath('t').text}"
						else
							forecast << " - Day: #{part.xpath('t').text}"
						end
					end
					event.connection.send_message(Rubybot::PluginSystem.get_target(event), forecast)	
				end
			else
				event.connection.send_message(Rubybot::PluginSystem.get_target(event), "City code not found.")
			end
		}
		end
	end

	def self.convert_to_c(value)
		if value =~ /^[\-0-9]*$/
			( value.to_i - 32 ) * 5 / 9
		else
			"N/A"
		end
	end
end
