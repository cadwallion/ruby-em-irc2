require 'rubygems'
require 'eventmachine'
require 'logger'

class CadClass
	include EM::Deferrable

	attr_accessor :handlers

	def initialize(args =  {})
		@handlers = []

	end

	def ping(x)
		send_to_server "NICK #{@nickname}"
		x.times { puts "pongs" }
	end
end

callback1 = Proc.new do |c|
	c.callback do |x|
		5.times { puts "pong" }
		EM.stop
	end
end

class IRCEvent
	include EventMachine::Deferrable
	
	def initialize(data)
		data.chomp!
		data.sub!(/^:/, '')
		mess_parts = data.split(':', 2)
		unless mess_parts.nil? || mess_parts.size < 2
			message  = mess_parts[1]
			stats = mess_parts[0].scan(/[\/\=\-\_\~\"\`\|\^\{\}\[\]\w.\#\@\+]+/)
			unless stats[0].nil?
				if stats[0].match(/^PING/)
					self.succeed("PONG #{message}")
				elsif stats[1] == "422"
					self.succeed("JOIN #coding")
				end
			end
		end
	end
end

class CadConnection < EventMachine::Connection
	attr_reader :realname, :username, :name
	attr_accessor :nickname	
	include EventMachine::Protocols::LineText2

	def initialize(args = {})

		@logger = Logger.new('cadbot.log')
		@name = args[:name] || "CadBotAlpha"
		@nickname = args[:nickname] || "CadBotAlpha"
		@realname = args[:realname] || "See Cadwallion"
		@username = args[:username] || "CadBotAlpha"
		super
	end

	def send_to_server(msg)
		@logger.info(msg)
		puts msg
		send_data(msg + "\n")
	end

	def post_init
		@logger.info "firing post_init"
	end
	
	def connection_completed
		send_to_server "NICK #{@nickname}"
		send_to_server "USER #{@username} 8 * :#{@realname}"
	end

	def	receive_line(line)
			@logger.info(line)
			puts line
			d = IRCEvent.new(line)
			d.callback { |resp| 
				puts "response: #{resp}"
				send_to_server resp
			}
	end
end

#connection = CadConnection.new(:nickname => "CadBotAlpha")

EM.run {
	EM.connect "deathknight.mmoirc.com", 6667, CadConnection
}
