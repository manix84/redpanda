module Admin_Helper
	private 
		def is_admin?(user)
			user.nick == 'jak'
		end
end