require 'cinch'

class Help
	include Cinch::Plugin

	match /help/

	def execute(m)
		m.reply "Never fear, help is here! " << HELP_URL
	end
end
