module Admin_Helper
	private 
		def is_admin?(user)
			user.nick == 'jak' || user.nick == 'Luke'
		end
end
