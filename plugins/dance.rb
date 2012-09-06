require 'cinch'

class Dance
	include Cinch::Plugin

	match /dance/, react_on: :channel

	def initialize(*args)
		super
		@dances = [
			'dances',
			'boogies',
			'jives',
			'waltzes',
			'body pops',
			'piroettes',
			'shuffles',
			'watches http://i.imgur.com/OwcuA.gif',
			'does the electric boogaloo'
		]
	end

	def execute(m)
		m.channel.action @dances.sample
	end
end
