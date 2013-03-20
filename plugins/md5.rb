require 'cinch'
require 'digest/md5'

class Md5
	include Cinch::Plugin

	match /md5 (.+)$/, method: :hash_it

	def hash_it(m, content)
		m.safe_reply Digest::MD5.hexdigest(content)
	end

end
