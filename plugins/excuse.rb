require 'cinch'
require 'nokogiri'
require 'rest-client'

class Excuse
  include Cinch::Plugin

  match /excuse/
  
  def execute(m)
    xml = Nokogiri::XML(RestClient.get 'http://programmingexcuses.com/')
    excuse = xml.xpath('//center/a')
    if not excuse.empty?
      m.reply excuse.text
    end
  end
end
