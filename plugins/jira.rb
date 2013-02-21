require 'cinch'
require 'mechanize'

class Jira
	include Cinch::Plugin

	match /\b([a-z]+-[0-9]+)\b/i, method: :get_issue, use_prefix: false, group: :jira
	match /(?:\s|^)([0-9]{4,5})(?:\s|$)/, method: :get_iplayer_issue, use_prefix: false, group: :jira
	match /jira ([a-z]+-[0-9]+)/i, method: :get_jira_issue, group: :jira

	def get_iplayer_issue(m, issue_number)
		return if m.channel != '#iplayer'
		issue = issue_title("IPLAYER-#{issue_number}")
		m.reply issue if not issue.empty?
	end

	def get_issue(m, issue_number)
		issue = issue_title(issue_number)
		m.reply issue if not issue.empty?
	end

	def get_jira_issue(m, issue_number)
		issue = issue_title(issue_number)
		if issue.empty?
			m.reply "That ticket doesn't appear to exist!"
		else
			m.reply issue
		end
	end

	def issue_title(issue)
		agent = Mechanize.new
		agent.cert = CERTIFICATE_PATH
		agent.key = CERTIFICATE_PATH
		url = "https://" << JIRA_HOST << "/browse/#{issue}"
		title = agent.get(url).title
		return "" if title.start_with? "ISSUE DOES NOT EXIST"
		return "#{title} - [ #{url} ]"
	end

end
