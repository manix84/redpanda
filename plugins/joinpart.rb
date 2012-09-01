require 'cinch'

class JoinPart
	include Cinch::Plugin

	match /join (.+)/, method: :join
	match /part(?: (.+))?/, method: :part

	def join(m, channel)
		m.reply "Joining #{channel} at the request of #{m.user.nick}"
		c = Channel(channel)
		c.join
		c.msg "Joined at the request of #{m.user.nick}"
	end

	def part(m, channel)
		channel ||= m.channel
		m.reply "Leaving #{channel} as the request of #{m.user.nick}"
		Channel(channel).part if channel
	end
end