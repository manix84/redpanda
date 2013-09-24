require 'cinch'

class Jira
    include Cinch::Plugin

    match(/\W#(\d+)\W/, method: :pull_request_url)

    def pull_request_url(m, pr_number)
        # Need to limit this to #iplayer as it hardcodes the URL
        return if m.channel != '#iplayer'
        url = "https://github.com/iplayer/responsive-web/pull/#{pr_number}"
        m.reply url
    end

end
