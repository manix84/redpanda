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
		Channel(channel).join
	end

	def part(m, channel)
		return unless is_admin?(m.user)
		channel ||= m.channel
		Channel(channel).part("coz #{m.user.nick} told me too :(") if channel
	end

end
