require 'cinch'
require 'github_api'

class PullRequest
    include Cinch::Plugin

    match %r{(?<!build )#(\d+)\b}, use_prefix: false
   
    def execute(m, issue)
      repos = { 
        "#iplayer" => "responsive-web",
        "#ibl" => "ibl"
      }
      if not repos.has_key?(m.channel) then
        puts "Channel #{m.channel} is not recognised by PullRequest"
        return
      end
      begin
        github = Github.new basic_auth: GITHUB_BASICAUTH
        issue = github.issues.get 'iplayer', repos[m.channel], issue
        m.reply "#{issue.title} [ #{issue.html_url} ]"
      rescue Github::Error::NotFound => e
        puts "Error #{e} for #{issue} on #{m.channel}"
      end
    end
end
