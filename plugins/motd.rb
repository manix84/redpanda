require 'cinch'

class Motd
	include Cinch::Plugin

	match /motd$/, method: :show_motd
	match /motd (.+)/, method: :set_motd

	def set_motd(m, contents)
		File.open(WEBROOT + '/motd.html', 'w') { |f|
			f.write('<html><style>body{background-color:#000;color:#fff;font-family:Arial;text-align:center} h1{font-size:4em} h2{font-size:1.5em}</style><body>')
			f.write("<h1>#{contents}</h1>")
			f.write("<h2>#{m.user.nick} at #{Time.new.ctime}</h2>")
			f.write('</body></html>')
		}
		m.safe_reply "Saved MOTD."
	end

	def show_motd(m)
		m.safe_reply "!motd Message"
		m.safe_reply "Will overwrite any previous MOTD, and will display on the TV."
	end

end
