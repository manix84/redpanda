DBFILE      = "/home/jak/bot/redpanda/sqlite.db"
CERTIFICATE_PATH = '/home/jak/certs/dev.bbc.co.uk.pem'

require 'cinch'
require 'data_mapper'
require_relative 'plugins/tube.rb'
require_relative 'plugins/karma.rb'
require_relative 'plugins/iplayer.rb'
require_relative 'plugins/hudsonbots.rb'
require_relative 'plugins/joinpart.rb'
require_relative 'plugins/help.rb'
require_relative 'plugins/shortcuts.rb'
require_relative 'plugins/jira.rb'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite:///' + DBFILE)

# If database doesn't exist, create. Else update
if File.exists?(DBFILE)
	DataMapper.auto_upgrade!
else
	DataMapper.auto_migrate!
end

bot = Cinch::Bot.new do
	configure do |c|
		c.server = 'irc.dev.bbc.co.uk'
		c.port = '6697'
		c.nick = 'redpanda'
		c.name = 'redpanda'
		c.user = 'redpanda'
		c.realname = 'iPlayer IRC Bot - Jak Spalding'
		c.channels = ['#iplayer']
		c.plugins.plugins = [
			TubeStatus, 
			Karma, 
			Iplayer, 
			HudsonBots, 
			JoinPart, 
			Help, 
			Shortcuts,
			Jira
		]
		c.ssl.use = true
		c.ssl.verify = false
		c.ssl.client_cert = CERTIFICATE_PATH
	end
end

bot.start
