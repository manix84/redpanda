require 'cinch'

class HudsonBots
	include Cinch::Plugin

	timer 30, method: :invite_bots

	def initialize(*args)
		super
		@bots = ["hudson-int-pal", "hudson-test-pal","hudson-int-app", "hudson-test-app"]
		@channels = ["#iplayer", "#ibl"]
	end

	def invite_bots
		@channels.each do |c|
			channel = Channel(c)
			@bots.each do |bot|
				channel.invite bot unless channel.has_user? bot
			end
		end
	end
end
