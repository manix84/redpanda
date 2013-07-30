require_relative 'config.rb'

require 'cinch'
require 'data_mapper'
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/plugins/*') {|file| require file}

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, DB_CONN_STRING)

# If database doesn't exist, create. Else update
if File.exists?(DBFILE)
	DataMapper.auto_upgrade!
else
	DataMapper.auto_migrate!
end

bot = Cinch::Bot.new do
	configure do |c|
		c.server = IRC_SERVER
		c.port = IRC_PORT
		c.nick = 'fabulouspony'
		c.name = 'fabulouspony'
		c.user = 'fabulouspony'
		c.realname = 'iPlayer Bot - Jak Spalding - try !help'
		c.channels = ['#iplayer', '#playback', '#ibl']
		c.plugins.plugins = [
			TubeStatus, 
			Iplayer, 
			HudsonBots, 
		  Admin, 
			Help, 
			Shortcuts,
			Jira,
			Dance,
			FeatureCrews,
			Cat,
			Build,
			Motd,
			Ctcp,
			Dontsay,
			Md5,
      Codereview,
      Fishslap,
      Excuse
		]
		c.ssl.use = true
		c.ssl.verify = false
		c.ssl.client_cert = CERTIFICATE_PATH
	end
end

bot.start
