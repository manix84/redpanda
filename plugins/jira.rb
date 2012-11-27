require 'cinch'
require 'mechanize'

class Jira
	include Cinch::Plugin

	match /(?:[\s,:\?\(]|^)([A-Za-z]+-[0-9]+)(?:[\)\s,:\?]|$)/, method: :get_issue, use_prefix: false
	match /(?:\s|^)(1[0-9]{4})(?:\s|$)/, method: :get_iplayer_issue, use_prefix: false

	def get_iplayer_issue(m, issue_number)
		get_issue m, "IPLAYER-#{issue_number}" if m.channel == '#iplayer'
	end

	def get_issue(m, issue)
		agent = Mechanize.new
		agent.cert = CERTIFICATE_PATH
		agent.key = CERTIFICATE_PATH
		url = "https://" << JIRA_HOST << "/browse/#{issue}"
		title = agent.get(url).title
		m.reply "#{title} - [ #{url}  ]"
	end

end