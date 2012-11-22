require 'cinch'
require 'nokogiri'
require 'rest-client'

class Cat
  include Cinch::Plugin

  match /cat/
  
  def execute(m)
    xml = Nokogiri::XML(RestClient.get 'http://thecatapi.com/api/images/get?format=xml&type=gif')
    url = xml.xpath('//url')
    if not url.empty?
      m.reply url.text
    end
  end
end
