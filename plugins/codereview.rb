require 'cinch'
require 'mechanize'
require 'nokogiri'

class Codereview
	include Cinch::Plugin

	match /reviews/i, method: :execute
  timer 3600, method: :notify

	def initialize(*args)
		super
	end

  def notify
    c = Channel('#ibl')
    issues = get_issues
    if issues.count > 0 then
      c.msg "These issues need reviewing:"
      issues.xpath('//item').each do |item|
        c.msg "#{item.xpath('title').text} [ #{item.xpath('link').text} ]"
      end
    end
  end


	def execute(m)
    issues = get_issues
    if issues.count == 0 then
      m.reply "Nothing needs reviewing! Good work!"
    else
      m.reply "These issues need reviewing:"
      issues.xpath('//item').each do |item|
        m.reply "#{item.xpath('title').text} [ #{item.xpath('link').text} ]"
      end
    end
	end

  def get_issues
		agent = Mechanize.new
		agent.ca_file = CA_PATH
		agent.cert = CERTIFICATE_PATH
		agent.key = CERTIFICATE_PATH
    jira_query = URI::encode('project = "iPlayer Business Layer" and status = "Resolved" and type in (Bug,Story)')
		url = "https://#{JIRA_HOST}/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml?jqlQuery=#{jira_query}&tempMax=1000"
		return Nokogiri::XML(agent.get(url).content).xpath('//item')
	end

end
