require 'cinch'
require_relative '../admin.rb'

class Admin
	include Cinch::Plugin
	include Admin_Helper

	match /join (.+)/, method: :join
	match /part(?: (.+))?/, method: :part
  match /nick (.+)/, method: :nick
  match /die/, method: :die

	def join(m, channel)
		return unless is_admin?(m.user)
		channel = "##{channel}" unless channel[0,1] == "#"
		Channel(channel).join
	end

	def part(m, channel)
		return unless is_admin?(m.user)
		channel ||= m.channel
		Channel(channel).part("coz #{m.user.nick} told me too :(") if channel
	end

  def nick(m, name)
###    return unless is_admin?(m.user)
    @bot.nick = name
  end

  def die(m)
    return unless is_admin?(m.user)
    @bot.quit "Quit command from #{m.user.nick}"
  end

end
