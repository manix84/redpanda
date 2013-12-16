require_relative 'config.rb'

require 'cinch'
require 'data_mapper'
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/plugins/*') {|file| require file}

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, DB_CONN_STRING)

DataMapper.auto_upgrade!

bot = Cinch::Bot.new do
	configure do |c|
		c.server = IRC_SERVER
		c.port = IRC_PORT
		c.nick = 'iPlayerBot'
		c.name = 'iPlayerBot'
		c.user = 'iPlayerBot'
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
			Excuse,
			PullRequest,
			Chatty,
			Autojoin
		]
		c.ssl.use = true
		c.ssl.verify = false
		c.ssl.client_cert = CERTIFICATE_PATH
	end
end

bot.start
