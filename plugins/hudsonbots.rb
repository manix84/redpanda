require 'cinch'

class HudsonBots
	include Cinch::Plugin

	listen_to :join

	def initialize(*args)
		super
		@hudsonbots = ["hudson-int-pal", "hudson-test-pal"]
	end

	def listen(m)
		return unless m.channel == '#iplayer'
		@hudsonbots.each do |bot|
			m.channel.invite(bot) unless m.channel.has_user?(bot)
		end
	end
end
