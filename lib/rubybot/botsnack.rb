class Botsnack
	def	self.give(params, event)
		event.succeed("PRIVMSG #{Rubybot::PluginSystem.get_target(event)} :Thank You! :)")
	end
end
