class HomepagesController < ApplicationController
	def homepage
		if session["user_id"] != nil
			@user = User.find(session["user_id"])
		end
		render :homepage
	end 
end