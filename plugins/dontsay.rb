class Dontsay
  include Cinch::Plugin

  match /don'?t say (.*)/i, use_prefix: false
  
  def execute(m, message)
    m.reply message
  end
end
