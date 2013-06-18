require 'cinch'

class Fishslap
	include Cinch::Plugin

	match /slap ?([a-z0-9\-_]*)/

	def execute(m, who)
    who = m.user.nick if who.empty?
		m.channel.action "slaps #{who} around a bit with a large trout"
	end
end
