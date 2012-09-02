require 'cinch'
require 'mechanize'

class Jira
	include Cinch::Plugin

	match /([A-Za-z]+-[0-9]+)/, method: :get_issue, use_prefix: false
	match /([4-9][0-9]{3})/, method: :get_iplayer_issue, use_prefix: false

	def get_iplayer_issue(m, issue_number)
		get_issue m, "IPLAYER-#{issue_number}"
	end

	def get_issue(m, issue)
		agent = Mechanize.new
		agent.cert = CERTIFICATE_PATH
		agent.key = CERTIFICATE_PATH
		url = "https://jira.dev.bbc.co.uk/browse/#{issue}"
		title = agent.get(url).title
		m.reply "#{title} - [ #{url}  ]"
	end

end