require 'cinch'

class Keepnick
  include Cinch::Plugin
  listen_to :nick

  def listen(m)
    @bot.nick = 'redpanda' 
  end
end
