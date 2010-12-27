module IRC
	class Handler

		def self.default_handlers
			handlers = {}
			handlers['ping'] = []
			handlers['ping'] << Proc.new {|e| e.succeed("PONG #{e.message}") }
			handlers
		end
	end
end
