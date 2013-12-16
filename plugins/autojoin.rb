require 'cinch'
require 'data_mapper'
require_relative '../admin.rb'

class AutojoinChannel
	include DataMapper::Resource
  property :id, Serial
	property :channel, String, unique: true
end

class Autojoin
	include Cinch::Plugin
	include Admin_Helper

	match /autojoin(?: (.+))?$/, method: :add
	match /autojoinoff(?: (.+))?$/, method: :remove 
  match /autojoinlist$/, method: :list
  listen_to :"255", method: :autojoin

  def list(m)
    channels = channel_list.join(", ")
    m.reply "Currently autojoining: #{channels}"
  end

  def autojoin(m)
    channel_list.each do |c|
      Channel(c).join
    end
  end

	def add(m, channel)
		return if is_not_admin(m)
	
		channel = get_channel_or_default channel, m.channel.name	
		
		if channel_list.include? channel
			m.reply "Already autojoining"
		else
			add_channel channel
			m.reply "Autojoin enabled for #{channel}"
			Channel(channel).join
		end
	end

	def remove(m, channel)
		return if is_not_admin(m)
		
		channel = get_channel_or_default channel, m.channel.name
		
		if channel_list.include? channel
			remove_channel channel
			m.reply "Autojoin disabled for #{channel}"
		else
			m.reply "Not currently autojoining"
		end
	end

	private

		def get_channel_or_default(channel, default_channel)
			channel ||= default_channel
			channel = "##{channel}" unless channel[0,1] == "#"
			return channel
		end

		def is_not_admin(m)
			if not is_admin?(m.user)
				m.reply "Only admin users may use that command"
				return true
			end
			return false
		end

		def channel_list
			AutojoinChannel.all.map { |c| c.channel }
		end

		def add_channel(channel)
			begin
				AutojoinChannel.create(:channel => channel)
			rescue => error
				puts error
			end
		end

		def remove_channel(channel)
			begin
				c = AutojoinChannel.first(:channel => channel)
				if c.nil?
					puts "No channel #{channel} in DB"
				else
					c.destroy
				end
			rescue => error
				puts error
			end
		end
end
