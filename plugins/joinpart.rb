require 'cinch'
require_relative '../admin.rb'

class JoinPart
	include Cinch::Plugin
	include Admin_Helper

	match /join (.+)/, method: :join
	match /part(?: (.+))?/, method: :part

	def join(m, channel)
		return unless is_admin?(m.user)
		channel = "##{channel}" unless channel[0,1] == "#"
		m.reply "Joining #{channel} at the request of #{m.user.nick}"
		c = Channel(channel)
		c.join
		c.msg "Joined at the request of #{m.user.nick}"
	end

	def part(m, channel)
		return unless is_admin?(m.user)
		channel ||= m.channel
		m.reply "Leaving #{channel} as the request of #{m.user.nick}"
		Channel(channel).part("coz #{m.user.nick} told me too :(") if channel
	end

end
