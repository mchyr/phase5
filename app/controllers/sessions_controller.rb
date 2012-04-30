class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.authenticate(params[:email], params[:password])
		if user
			session[:user_id] = user.user_id
			if user.role? 'admin'
				redirect_to admin_dash_path, notice: "Welcome!"
			elsif user.role? 'manager'
				redirect_to manager_dash_path, notice: "Hello!"
			elsif user.role? 'employee'
				redirect_to employee_dash_path
			else
				redirect_to root_url, notice: "Logged in!"
			end
		else
			redirect_to login_path, notice: "Invalid login or password."
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_url, :notice => "You have been logged out."
	end
end