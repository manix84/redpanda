require 'rubygems'
require 'daemons'
require_relative 'config.rb'

module Daemons
  class Application
    def logfile
      DIR_PATH << '/log.log'
    end
    def output_logfile
      DIR_PATH << '/output.log'
    end
  end
end

Daemons.run 'redpanda.rb',
  :dir => DIR_PATH,
  :dir_mode => :normal,
  :ontop => false,
  :log_output => true

