module IRC
	class Event
		attr_accessor :connection, :message

		include EventMachine::Deferrable
		
		def initialize(data, connection)
			@connection = connection
			data.chomp!
			data.sub!(/^:/, '')
			mess_parts = data.split(':', 2)
			unless mess_parts.nil? || mess_parts.size < 2
				@message  = mess_parts[1]
				stats = mess_parts[0].scan(/[\/\=\-\_\~\"\`\|\^\{\}\[\]\w.\#\@\+]+/)
				unless stats[0].nil?
					if stats[0].match(/^PING/)
						event = 'ping'
					elsif stats[1] && stats[1].match(/^\d+$/)
						event = IRC::EventLookup.find_by_number(stats[1].to_i)
					else
						event = stats[2].downcase if stats[2]
					end
					run_handlers(event) unless event.nil?
				end
			end
		end

		def run_handlers(event)
			unless connection.handlers.size == 0 || connection.handlers[event].nil?
				connection.handlers[event].each do |handler|
					handler.call(self) unless handler.nil?
				end
			end
		rescue => err
			puts "Error running handler"
			connection.logger.debug err.message
		end
	end
end
