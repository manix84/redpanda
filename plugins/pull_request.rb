require 'cinch'
require 'github_api'

class PullRequest
    include Cinch::Plugin

    match %r{([\w\-]+)#(\d+)}, use_prefix: false, method: :with_project, group: :pull
    match %r{#(\d+)}, use_prefix: false, method: :without_project, group: :pull
   
    def without_project(m, issue)
      return if m.user.nick.include? "hudson"
      default_repos = { 
        "#iplayer" => "responsive-web",
        "#ibl" => "ibl"
      }
      if not default_repos.has_key?(m.channel) then
        puts "Channel #{m.channel} is not recognised by PullRequest"
        return
      end
      with_project(m, default_repos[m.channel], issue)
    end

    def with_project(m, project, issue)
      begin
        github = Github.new basic_auth: GITHUB_BASICAUTH
        issue = github.issues.get 'iplayer', project, issue
        m.reply "#{issue.title} [ #{issue.html_url} ]"
      rescue Github::Error::NotFound => e
        puts "Error #{e} for #{issue} on #{m.channel}"
      end
    end
end
