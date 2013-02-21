require 'cinch'
require 'data_mapper'

class Shortcut
	include DataMapper::Resource

	property :id, Serial
	property :command, String, unique: true
	property :contents, String, length: 300
	property :created_by, String
end

class Shortcuts
	include Cinch::Plugin

	match /set ([A-Za-z0-9]+) (.+)/, method: :add_shortcut
	match /^\?([A-Za-z0-9]+)/, method: :get_shortcut, use_prefix: false
	match /shortcuts/, method: :list_shortcuts
	match /shortcutdelete ([A-Za-z0-9]+)/, method: :delete_shortcut

	def add_shortcut(m, command, contents)
		begin
			shortcut = Shortcut.first_or_new(
				{ :command.like => command.downcase.strip },
				{ :command => command.downcase.strip }
			)
			shortcut.contents = contents
			shortcut.created_by = m.user.nick
			shortcut.save
			m.safe_reply "Saved, use ?#{command} to retrieve or !shortcuts to see all"
		rescue => error
			m.reply "Uh-oh spaghetti-o's!"
		end
	end

	def get_shortcut(m, command)
		begin
			shortcut = Shortcut.first(:command.like => command.downcase.strip)
			if shortcut.nil?
				shortcuts = Shortcut.all(:command.like => "%#{command.downcase.strip}%")
				if shortcuts.count == 1
					m.safe_reply "I don't recognise that. Did you mean #{shortcuts.first.command}? (Type ?#{shortcuts.first.command})"
				elsif shortcuts.count > 1
					m.safe_reply "Hmm.. did you mean one of these: #{shortcuts.map { |s| s.command }.join(' ')} ?"
				else
					m.safe_reply "Nothing was found! To see all shortcuts, type !shortcuts"
				end
			else
				m.safe_reply "?? #{shortcut.contents}"
				m.safe_reply "?? #{shortcut.command} added by #{shortcut.created_by}"
			end
		rescue => error
			m.reply "Uh-oh spaghetti-o's!"
		end
	end

	def list_shortcuts(m)
		begin
			shortcuts = Shortcut.all(fields: [:command])
			commands = []
			shortcuts.each do |s|
				commands << "?#{s.command}"
			end
			m.safe_reply "Available shortcuts: " << commands.join(', ')
			m.reply "Add a new shortcut using '!set <shortcut> <some text here>'"
		rescue
			m.reply "Uh-oh spaghetti-o's!"
		end
	end

	def delete_shortcut(m, command)
		begin
			shortcut = Shortcut.first(:command.like => command.downcase.strip)
			if shortcut.nil?
				m.reply "Hmm.. no such shortcut in the database"
				return
			end
			shortcut.destroy
			m.safe_reply "Shortcut ?#{command} deleted."
		rescue
			m.reply "Uh-oh spaghetti-o's!"
		end
	end

end
