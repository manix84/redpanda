require 'cinch'
require 'data_mapper'

class Team
	include DataMapper::Resource

	has n, :members

	property :name, String, unique: true, key: true
end

class Member
	include DataMapper::Resource

	belongs_to :team

	property :id, Serial
	property :nick, String
end

class FeatureCrews
	include Cinch::Plugin

	match /team add ([A-Za-z]+) ([A-Za-z0-9\-]+)/, method: :add_member
	match /team remove ([A-Za-z]+) ([A-Za-z0-9\-]+)/, method: :remove_member
	match /team create ([A-Za-z]+)/, method: :create_team
	match /team delete ([A-Za-z]+)/, method: :delete_team
	match /team members ([A-Za-z]+)/, method: :list_members
	match /team list$/, method: :list_teams
	match /team help/, method: :help
	match /team$/, method: :help
	match /^everyone[,:$]/, method: :list_everyone, use_prefix: false
	match /^([A-Za-z]+?)s?[,:$]/, method: :list_members, use_prefix: false

	def help(m)
		m.reply "Usage: !team (add|remove) <team> <nickname>"
		m.reply "Usage: !team (members|create|delete) <team>"
		m.reply "Usage: !team (list|help)"
	end

	def create_team(m, team_name)
		begin
			team = Team.create(:name => team_name.downcase.strip)
			m.safe_reply "Created a new team, Team #{team_name.capitalize}!"
			m.safe_reply "Add yourself using !team add #{team_name} #{m.user.nick}"
		rescue => error
			m.reply "Uh-oh spaghetti-o's"
		end
	end

	def delete_team(m, team_name)
		begin
			team = Team.get(team_name.downcase)
			team.destroy
			m.reply "Team deleted :-("
		rescue
			m.reply "Uh-oh spaghetti-o's"
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

	def list_members(m, team_name)
		begin
			members = Team.get(team_name.downcase).members.all(fields: [:nick])
			nicks = []
			members.each do |member|
				nicks << member.nick
			end
			m.safe_reply nicks.join(', ')
		rescue
			#do nothing, because this listens to conversations too!
		end
	end

	def list_teams(m)
		begin
			teams = Team.all(fields: [:name])
			names = []
			teams.each do |team|
				names << "Team #{team.name.capitalize}"
			end
			m.safe_reply names.join(', ')
		rescue
			m.reply "Uh-oh spaghetti-o's"
		end
	end

	def list_everyone(m)
		begin
			members = Member.all(fields: [:nick])
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
