require 'rubygems'
require 'em-synchrony'
require 'em-synchrony/em-http'
require File.dirname(__FILE__) + '/lib/em-ruby-irc'
require File.dirname(__FILE__) + '/lib/rubybot/rubybot'
require File.dirname(__FILE__) + '/lib/extensions'

require File.dirname(__FILE__) + '/lib/rubybot/botsnack'
require File.dirname(__FILE__) + '/lib/rubybot/weather'
require File.dirname(__FILE__) + '/lib/rubybot/eight_ball'

networks = [
	{ 
		:server => "deathknight.mmoirc.com",
		:port => 6667,
		:nickname => "CadBotAlpha",
		:realname => "See Cadwallion",
		:username => "CadBotAlpha",
		:channels => ["#coding"]
	}
]

bot = Rubybot::Bot.new
bot.plugin_system.add_plugin("botsnack", "Botsnack#give")
bot.plugin_system.add_plugin("weather", "CadWeather#weather")
bot.plugin_system.add_plugin("8ball", "EightBall#answer")
bot.connect(networks)
Process.daemon()
