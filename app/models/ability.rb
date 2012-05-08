class Ability
	include CanCan::Ability

	def initialize(user)

		user ||= User.new
		if user.role? "admin"
			can :manage, :all
		elsif user.role? "manager"
			can :update, Employee do |employee|
				!user.employee.current_assignment.nil? && !employee.current_assignment.nil? && employee.current_assignment.store_id == user.employee.current_assignment.store_id
			end
			can :read, Employee do |employee|
				!user.employee.current_assignment.nil? && !employee.current_assignment.nil? && employee.current_assignment.store_id == user.employee.current_assignment.store_id
			end
			can :show, Store
			can :show, Shift
			can :create, Shift
			can :update, Shift do |shift|
				shift.assignment.store_id == user.employee.current_assignment.store_id
			end
			can :destroy, Shift do |shift|
				shift.assignment.store_id == user.employee.current_assignment.store_id
			end
			can :create, ShiftJob
			can :update, ShiftJob

			can :create, Job
			can :update, Job
			can :show, Job

		elsif user.role? "employee"
			can :show, Shift do |shift|
				user.employee.current_assignment.shifts.include?(shift)
			end
			can :show, Store
			can :show, Employee do |employee|
				employee == user.employee
			end
		else
			can :show, Store
		end
	end
end
			