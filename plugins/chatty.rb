require 'cinch'
require 'statsd'

class Chatty
	include Cinch::Plugin

	listen_to :channel, method: :message
  listen_to :join, method: :joinpart
  listen_to :part, method: :joinpart

  def initialize(bot)
    super(bot)
    @statsd = Statsd.new STATSD_SERVER, STATSD_PORT
    @statsd.namespace = "irc"
  end

	def message(m)
		@statsd.increment "messages.#{m.channel.to_s.downcase}.#{m.user.nick}"
	end

  def joinpart(m)
    @statsd.gauge "occupancy.#{m.channel.to_s.downcase}", m.channel.users.size
  end
end
