require 'cinch'

class Help
	include Cinch::Plugin

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
		m.reply "huh" 
	end
end
