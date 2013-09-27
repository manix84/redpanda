require 'cinch'
require 'data_mapper'
require_relative '../admin.rb'

class Team
	include DataMapper::Resource

	has n, :members, constraint: :destroy

	property :name, String, unique: true, key: true
  property :channel, String
end

class Member
	include DataMapper::Resource

	belongs_to :team

	property :id, Serial
	property :nick, String
end

class FeatureCrews
	include Cinch::Plugin
	include Admin_Helper

	match /team add ([A-Za-z]+) ([A-Za-z0-9\-]+)/, method: :add_member
	match /team remove ([A-Za-z]+) ([A-Za-z0-9\-]+)/, method: :remove_member
	match /team create ([A-Za-z]+)/, method: :create_team
	match /team delete ([A-Za-z]+)/, method: :delete_team
	match /team members ([A-Za-z]+)/, method: :always_list_members
	match /team list$/, method: :list_teams
	match /team help/, method: :help
	match /team$/, method: :help
	match /^((has|does|is)\s*)?(any|every)(one|body)/i, method: :list_everyone, use_prefix: false
	match /([a-z]+)'?s\b/i, method: :sometimes_list_members, use_prefix: false
	match /team ([a-z]+)\b/i, method: :sometimes_list_members, use_prefix: false
  match /team chanassign ([A-Za-z]+) ?(#[A-Za-z0-9\-_]+)?$/, method: :assign_channel
  match /team chanassign ([A-Za-z]+) all$/, method: :unassign_channel

	def help(m)
		m.reply "Usage: !team (add|remove) <team> <nickname>"
    m.reply "Usage: !team chanassign <team> (<#channel>|all)"
    m.reply "Usage: !team (members|create|delete) <team>"
		m.reply "Usage: !team (list|help)"
	end

	def create_team(m, team_name)
		return unless is_admin?(m.user)
		begin
			team = Team.create(:name => team_name.downcase.strip)
			m.safe_reply "Created a new team, Team #{team_name.capitalize}!"
			m.safe_reply "Add yourself using !team add #{team_name} #{m.user.nick}"
		rescue => error
			m.reply "Uh-oh spaghetti-o's"
		end
	end

	def delete_team(m, team_name)
		return unless is_admin?(m.user)
		begin
			Team.get(team_name.downcase).destroy
			m.reply "Team deleted :-("
		rescue => error
			puts error
			m.reply "Uh-oh spaghetti-o's"
		end
	end

  def assign_channel(m, team_name, channel_name)
    return unless is_admin?(m.user)
    begin
      team = Team.get(team_name.downcase)      
      team.channel = channel_name || m.channel
      team.save
      m.safe_reply "Team #{team_name} now assigned to #{team.channel}"
    rescue => e
      m.reply "Uh-oh spaghetti-o's"
      puts e
    end
  end

  def unassign_channel(m, team_name)
    return unless is_admin?(m.user)
    begin
      team = Team.get(team_name.downcase)
      team.channel = nil
      team.save
      m.safe_reply "Team #{team_name} no longer assigned to any channel"
    rescue => e
      m.reply "Uh-oh spaghetti-o's"
      puts e
    end
  end

	def add_member(m, team_name, member_name)
		begin
			team = Team.get(team_name.downcase)
			member = Member.create(:nick => member_name, :team => team)
			m.safe_reply "Added #{member_name} to Team #{team_name.capitalize}"
		rescue
			m.reply "Uh-oh spaghetti-o's"
		end
	end

	def remove_member(m, team_name, member_name)
		begin
			member = Team.get(team_name.downcase).members.first(:nick => member_name)
			if member.nil?
				m.safe_reply "Couldn't find #{member_name} in Team #{team_name.capitalize}"
				return
			end
			member.destroy
			m.safe_reply "#{member_name} has been removed from Team #{team_name.capitalize}"
		rescue
			m.reply "Uh-oh spaghetti-o's"
		end
	end

  def always_list_members(m, team_name) 
    list_members(m, team_name, true)
  end

  def sometimes_list_members(m, team_name)
    list_members(m, team_name, false)
  end

	def list_members(m, team_name, always_speak)
		begin
      team = Team.get(team_name.downcase)
      return if !always_speak and (team.channel != m.channel or team.channel == nil)
			members = team.members.all(fields: [:nick])
			nicks = []
			members.each do |member|
				nicks << member.nick
			end
			m.safe_reply nicks.join(', ')
      m.safe_reply "No team members yet" if always_speak and nicks.empty?
		rescue
			#do nothing, because this listens to conversations too!
		end
	end

	def list_teams(m)
		begin
			teams = Team.all(fields: [:name, :channel])
			names = []
			teams.each do |team|
				names << "Team #{team.name.capitalize} (#{team.channel || "All"})"
			end
			m.safe_reply names.join(', ')
		rescue
			m.reply "Uh-oh spaghetti-o's"
		end
	end

	def list_everyone(m)
		begin
      teams = Team.all(:channel => m.channel) | Team.all(:channel => nil)
      members = teams.members.all(fields: [:nick])
			names = []
			members.each do |m|
				names << m.nick
			end
			m.reply names.uniq.join(', ')
		rescue
			m.reply "Uh-oh spaghetti-o's"
		end
	end

end
