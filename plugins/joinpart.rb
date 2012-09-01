require 'cinch'

class JoinPart
  include Cinch::Plugin

  match /join (.+)/, method: :join
  match /part(?: (.+))?/, method: :part

  def join(m, channel)
    Channel(channel).join
  end

  def part(m, channel)
    channel ||= m.channel
    Channel(channel).part if channel
  end
end