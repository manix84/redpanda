require 'cinch'

class Iplayer
	include Cinch::Plugin

	listen_to :join

	def listen(m)
		if m.user.nick == bot.nick and m.channel.downcase == '#iplayer'.downcase
			m.channel.topic = "Welcome to iPlayer! For Dynamite, try #metadata-serving - For the EMP, try #mediaplayout"
		end
	end
end
