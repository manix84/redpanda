require 'cinch'

class DoDance
	include Cinch::Plugin

	react_on :channel
	match /dance/

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
			'watches http://i.imgur.com/OwcuA.gif'
		]
	end

	def execute(m)
		m.channel.action @dances.sample
	end
end
