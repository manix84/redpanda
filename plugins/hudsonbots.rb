require 'cinch'

class HudsonBots
	include Cinch::Plugin

	listen_to :join

	def initialize(*args)
		super
		@palbots = ["hudson-int-pal", "hudson-test-pal"]
		@appbots = ["hudson-int-app", "hudson-test-app"]
	end

	def listen(m)

		if m.channel == '#iplayer'
			@palbots.each do |bot|
				m.channel.invite(bot) 
			end
		end
		if m.channel == '#ibl' 
			@appbots.each do |bot|
				m.channel.invite(bot)
			end
		end
	end
end
