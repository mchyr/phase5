class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_timezone

  def set_timezone
  	Time.zone = "Eastern Time (US & Canada)"
  end

  private
  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
  end

  def logged_in?
  	current_user
  end
  helper_method :logged_in?

  def check_login
  	redirect_to login_url, alert: "You need to log in to view this page." if current.user.nil?
  end

  def has_incomplete_shifts?
  	if current_user.nil? || current_user.employee.current_assignment.nil?
  		return false
  	end
  	Shift.for_store(current_user.employee.current_assignment.store.id).past.incomplete.size > 0
  end
  helper_method :has_incomplete_shifts?

  def has_unfilled_hours?
  	if current_user.nil? || current_user.employee.current_assignment.nil?
  		return false
  	end
  	@store = current_user.employee.current_assignment.store
  	@store.get_unworked_hours_for_week.flatten.include?(1)
  end
  helper_method :has_unfilled_hours?

  rescue_from CanCan::AccessDenied do |exception|
  	redirect_to root_url, notice: "You do not have permission to access that."
  end

end
