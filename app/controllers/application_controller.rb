class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  rescue ActiveRecord::RecordNotFound
  end
  helper_method :current_user

  def logged_in?
    current_user
  end
  helper_method :logged_in?

  def check_login
    redirect_to login_url, alert: "You must log in to view this page." if current_user.nil?
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, notice: "You do not have permission to access that."
  end
end