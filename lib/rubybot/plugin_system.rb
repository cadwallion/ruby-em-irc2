module Rubybot
	class PluginSystem
		attr_accessor :plugins, :triggers

		def initialize
			@plugins = []
			@triggers = {}
		end

		def self.default_handlers
			@message_handler = Proc.new do |event|
				event.connection.config[:bot].plugin_system.process_event(event)
			end

			{
				'privmsg' =>  @message_handler
			}
		end

		def self.get_target(event)
			if event.channel =~ /#(.*)/
				return event.channel
			else
				return event.from
			end
		end

		#usage add_plugin("botsnack", "BotSnack#give")
		def add_plugin(trigger, action)
			@triggers[trigger] = action
		end

		def process_event(event)
			event.connection.logger.debug "PROCESSOR FIRED"
			if event.message =~ Regexp.new("^#{event.connection.command_char}(.*)", true)
				params = event.message.sub("#{event.connection.command_char}","").split(" ")
				if @triggers.has_key? params[0]
					handler = @triggers[params[0]].split("#")
					handler[0].constantize.send(handler[1], params, event)
				end
				event.connection.logger.debug "PROCESSOR OVER"
			end
		end

	end
end
