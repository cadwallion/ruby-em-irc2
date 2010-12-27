require 'rubygems'
require './lib/em-ruby-irc'

networks = [
	{ 
		:server => "deathknight.mmoirc.com",
		:port => 6667,
		:nickname => "CadBotAlpha",
		:realname => "See Cadwallion",
		:username => "CadBotAlpha"
	}
]

EM.run {
	EM.connect "deathknight.mmoirc.com", 6667, IRC::Connection
}
