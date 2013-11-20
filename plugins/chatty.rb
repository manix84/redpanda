require 'cinch'
require 'statsd'

class Chatty
	include Cinch::Plugin

	listen_to :channel

  def initialize
    @statd = Statsd.new STATSD_SERVER, STATSD_PORT
  end

	def listen(m)
		@statsd.increment "irc.messages.#{m.channel.to_s.downcase}.#{m.user.nick}"
	end
end
