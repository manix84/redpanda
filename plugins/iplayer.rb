require 'cinch'

class Iplayer
	include Cinch::Plugin

	listen_to :join

	def listen(m)
		if m.user.nick == bot.nick and m.channel.to_s.downcase == 'iplayer'
			m.channel.topic = "Welcome to iPlayer! For Dynamite, try #psem - For the EMP, try #mediaplayout"
			m.channel.mode "-t"
		end
	end
end
