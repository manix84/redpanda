require 'cinch'

class HudsonBots
	include Cinch::Plugin

	listen_to :join

	def initialize(*args)
		super
		@bots = ["hudson-int-pal", "hudson-test-pal","hudson-int-app", "hudson-test-app"]
	end

	def listen(m)
		if m.channel == '#iplayer' or m.channel == '#ibl'
			@bots.each do |bot|
				m.channel.invite(bot) 
			end
		end
	end
end
