require 'rubygems'
#require 'eventmachine'
require 'logger'
require 'yaml'

require File.dirname(__FILE__) + '/irc/connection'
require File.dirname(__FILE__) + '/irc/connection_helpers'
require File.dirname(__FILE__) + '/irc/event'
require File.dirname(__FILE__) + '/irc/event_lookup'
require File.dirname(__FILE__) + '/irc/handler'

module IRC
	VERSION='0.0.1'
end
