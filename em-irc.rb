require 'rubygems'
require 'em-synchrony'
require 'em-synchrony/em-http'
require './lib/em-ruby-irc'
require './lib/rubybot/rubybot'
require './lib/extensions'

require './lib/rubybot/botsnack'
require './lib/rubybot/weather'

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
bot.connect(networks)
