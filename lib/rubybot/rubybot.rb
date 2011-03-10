require File.dirname(__FILE__) + '/plugin_system'

module Rubybot
	class Bot
		attr_accessor :plugin_system, :connections
	
		def initialize(args ={})
			@plugin_system = Rubybot::PluginSystem.new
		end

		def connect(connections)
			EM.synchrony do
				connections.each do |connection|
					config = {
						:handlers => Rubybot::PluginSystem.default_handlers,
						:bot => self
					}
					config.merge!(connection)
					EM.connect(config[:server], config[:port], IRC::Connection, :config => config)
				end
			end
		end
	end
end
