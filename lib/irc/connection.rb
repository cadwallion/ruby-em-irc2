require 'eventmachine'

module IRC
	class Connection < EventMachine::Connection
		attr_reader :realname, :username, :name, :logger
		attr_accessor :nickname, :handlers	
		include EventMachine::Protocols::LineText2

		def initialize(args = {})
			@handlers = IRC::Handler.default_handlers
			#add_handler("ping", Proc.new { |h| h.succeed("PONG #{h.message}") })
			@logger = Logger.new('cadbot.log')
			@name = args[:name] || "CadBotAlpha"
			@nickname = args[:nickname] || "CadBotAlpha"
			@realname = args[:realname] || "See Cadwallion"
			@username = args[:username] || "CadBotAlpha"
			super
		end

		def add_handler(event, blk)
			@handlers[event] ||= []
			@handlers[event] << blk
		end
	
		def send_to_server(msg)
			@logger.info(msg)
			puts msg
			send_data(msg + "\n")
		end

		def connection_completed
			send_to_server "NICK #{@nickname}"
			send_to_server "USER #{@username} 8 * :#{@realname}"
		end

		def	receive_line(line)
			@logger.info(line)
			puts line
			d = IRC::Event.new(line, self)
			d.callback { |resp| 
				@logger.info("response: #{resp}")
				send_to_server resp unless resp.empty?
			}
		end
	end
end
