require 'cinch'

class Iplayer
	include Cinch::Plugin

	listen_to :join

	def listen(m)
		if m.user.nick == bot.nick
			m.channel.topic = "Welcome to iPlayer! For Dynamite, try #metadata-serving - For the EMP, try #mediaplayout"
			m.channel.mode = "-t"
		end
	end
end
