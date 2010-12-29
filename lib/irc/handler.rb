module IRC
	class Handler
		def self.default_handlers
			@nick_in_use_handler = Proc.new do |event|
				new_nickname = event.connection.nickname[0,14] + rand(9).to_s
				event.callback { event.connection.send_to_server("NICK #{new_nickname}") }
				event.succeed("USER #{event.connection.username} 8 * :#{event.connection.realname}")
				event.connection.nickname = new_nickname
			end

			@ping_handler = Proc.new do |event| 
				event.succeed("PONG #{event.message}")
			end
			
			@startup_handler = Proc.new do |event|
				event.connection.run_startup_handlers
			end


			handlers = {}
			handlers['ping'] = []
			handlers['ping'] << @ping_handler
			handlers['nicknameinuse'] = []
			handlers['nicknameinuse'] << @nick_in_use_handler
			handlers['endofmotd'] = []
			handlers['endofmotd'] << @startup_handler
			handlers['nomotd'] = []
			handlers['nomotd'] << @startup_handler
			handlers
		end
	end
end
