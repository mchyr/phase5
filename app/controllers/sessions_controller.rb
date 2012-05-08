class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_email(params[:email])
		if user #&& user.authenticate(params[:password])
			if params[:remember_me]
				cookies.permanent[:auth_token] = user.auth_token
			else
				cookies[:auth_token] = user.auth_token
			end

			if user.role? 'admin'
				redirect_to admin_dash_path, notice: "Welcome!"
			elsif user.role? 'manager'
				redirect_to manager_dash_path, notice: "Hello!"
			elsif user.role? 'employee'
				redirect_to employee_dash_path
			else
				redirect_to root_url, notice: "You are logged in."
			end
		else
			redirect_to login_path, notice: "Invalid login or password."
		end
	end

	def destroy
		cookies.delete(:auth_token)
		redirect_to root_url, :notice => "You have been logged out."
	end
end