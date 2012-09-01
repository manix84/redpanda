require 'cinch'
require_relative 'plugins/tube.rb'
require_relative 'plugins/karma.rb'
require_relative 'plugins/iplayer.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.dev.bbc.co.uk'
    c.port = '6697'
    c.nick = 'redpanda2'
    c.name = 'redpanda'
    c.realname = 'iPlayer IRC Bot - Jak Spalding'
    c.channels = ['#iplayer']
    c.plugins.plugins = [TubeStatus, Karma, Iplayer]
    c.ssl.use = true
    c.ssl.verify = false
    c.ssl.client_cert = '/home/jak/certs/dev.bbc.co.uk.pem'
  end
end

bot.start
