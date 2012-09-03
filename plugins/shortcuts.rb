require 'cinch'
require 'data_mapper'

class Shortcut
	include DataMapper::Resource

	property :id, Serial
	property :command, String, unique: true
	property :contents, String
	property :created_by, String
end

class Shortcuts
	include Cinch::Plugin

	match /set ([A-Za-z0-9]+) (.+)/, method: :add_shortcut
	match /\?([A-Za-z0-9]+)/, method: :get_shortcut, use_prefix: false

	def add_shortcut(m, command, contents)
		begin
			shortcut = Shortcut.first_or_new(
				{ :command.like => command.downcase.strip },
				{ :command = > command.downcase.strip }
			)
			shortcut.contents = contents
			shortcut.created_by = m.user.nick
			shortcut.save
			m.reply "Saved, use ?#{command} to retrieve"
		rescue => error
			m.reply "Uh-oh spaghetti-o's!"
		end
	end

	def get_shortcut(m, command)
		begin
			shortcut = Shortcut.first(:command.like => command.downcase.strip)
			if shortcut.nil?
				m.reply "Nothing found. Add something using '!set #{command.strip} useful stuff here'"
			else
				m.reply shortcut.contents
			end
		rescue => error
			m.reply "Uh-oh spaghetti-o's!"
		end
	end
end
