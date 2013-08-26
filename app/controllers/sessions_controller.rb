class SessionsController < ApplicationController
	def create
		auth = env["omniauth.auth"]
		member = Member.find_by_fbid(auth.uid)
		if member && member.admin_id?
			session[:member_id] = member.id
			source = session[:source] || :root
			session[:source] = nil
			redirect_to source, :notice => "Signed in!"
		else
			redirect_to :root, :notice => "You aren't an admin!"
		end
	end

	def destroy
		reset_session
		redirect_to :root, :notice => "Signed out!"
	end
end
