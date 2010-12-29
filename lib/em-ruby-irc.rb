require 'rubygems'
#require 'eventmachine'
require 'logger'
require 'yaml'

require './lib/irc/connection'
require './lib/irc/connection_helpers'
require './lib/irc/event'
require './lib/irc/event_lookup'
require './lib/irc/handler'

module IRC
	VERSION='0.0.1'
end
