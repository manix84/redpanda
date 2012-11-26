require 'cinch'

class Keepnick
  include Cinch::Plugin
  listen_to :nick

  def listen(m)
    @bot.nick = @bot.shared.nick 
  end
end
