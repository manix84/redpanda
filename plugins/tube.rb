require 'rest-client'
require 'json'
require 'htmlentities'

class TubeStatus
  include Cinch::Plugin
  
  match /tube$/i
  match /tube (\w+)$/i

  def execute(m, stations='all')
    url = "http://api.tubeupdates.com/?method=get.status&lines=#{stations}"
    response = JSON.parse(RestClient.get url)
    parsed = response['response']
    if response['response'] && response['response']['lines']
      response['response']['lines'].group_by { |line| line['status'] }.each do |status, lines|
       status = "#{status} - #{lines.map { |l| l['name'] }.join(', ')}"
       m.reply HTMLEntities.new.decode(status)
      end
    elsif response['response'] && response['response']['error']
      m.reply "Error: #{response['response']['error']}"
    else
      m.reply 'Epic tube fail'
    end
  end
end
