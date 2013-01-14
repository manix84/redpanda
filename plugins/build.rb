require 'cinch'
require 'mechanize'

class Build
	include Cinch::Plugin

	match /build/

	def execute(m)
		agent = Mechanize.new
		agent.cert = CERTIFICATE_PATH
		agent.key = CERTIFICATE_PATH
		url = "https://" << HUDSON_HOST << "/hudson/job/tviplayer-deploy/build?cause=IRC+Build&token=" << HUDSON_TOKEN
		title = agent.get(url).title
		m.reply "#{title} - [ #{url}  ]"
	end

end