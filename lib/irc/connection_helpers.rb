module IRC
	module ConnectionHelpers
		def join(channel)
			send_to_server("JOIN #{channel}")
		end

		def part(channel)
			send_to_server("PART #{channel}")
		end

		def quit(msg)
			send_to_server("QUIT :#{msg}")
		end
		
		def send_message(target, msg)
			send_to_server("PRIVMSG #{target} :#{msg}")
		end
	end
end
