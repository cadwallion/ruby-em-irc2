require 'eventmachine'
require './lib/irc/connection_helpers'
module IRC
	class Connection < EventMachine::Connection
		attr_reader :realname, :username, :name, :logger, :command_char
		attr_accessor :nickname, :handlers, :channels, :connected, :config

		include EventMachine::Protocols::LineText2
		include IRC::ConnectionHelpers

		def initialize(args)
			@logger = Logger.new('cadbot.log')
			@config = args[:config]
			@handlers = IRC::Handler.default_handlers
			@config[:handlers].each do |k,v|
				@handlers[k] = []
				@handlers[k] << v
			end
			puts @config.inspect
			puts @handlers
			@name = @config[:name] || "CadBotAlpha"
			@nickname = @config[:nickname] || "Cadwallion"
			@realname = @config[:realname] || "See Cadwallion"
			@username = @config[:username] || "CadBotAlpha"
			@command_char = @config[:command_char] || "@"
			@channels = @config[:channels] || []
			@connected = false
			super
		end

		def connected?
			@connected
		end
		
		def add_handler(event, blk)
			@handlers[event]
			@handlers[event] << blk
		end
	
		def send_to_server(msg)
			@logger.info(msg)
			puts msg
			send_data(msg + "\r\n")
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

		def run_startup_handlers
			@channels.each { |c| join(c) }
		end
	end
end
