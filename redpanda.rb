require 'cinch'
require_relative 'plugins/tube.rb'
require_relative 'plugins/karma.rb'
require_relative 'plugins/iplayer.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.dev.bbc.co.uk'
    c.port = '6697'
    c.nick = 'redpanda'
    c.channels = ['#iplayer']
    c.plugins.plugins = [TubeStatus, Karma, Iplayer]
    c.ssl.use = true
    c.ssl.verify = false
    c.ssl.client_cert = '/home/jak/'
  end
end

bot.start
