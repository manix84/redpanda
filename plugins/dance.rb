require 'cinch'

class Dance
	include Cinch::Plugin

	match /dance(?: (.+))?$/, react_on: :channel

	def initialize(*args)
		super
		@dances = [
      'twerks',
      'dances',
			'boogies',
			'jives',
			'waltzes',
			'body pops',
			'pirouettes',
			'does the electric boogaloo'
		]
	end

	def execute(m, extra)
		m.channel.action "#{@dances.sample} #{extra}"
	end
end
