class Ability
	include CanCan::Ability

	def initialize(user)

		user ||= User.new
		if user.role == 'admin'
			can :manage, :all
		elsif user.role == 'manager'
			can :update, Employee do |employee|
				employee.current_assignment.store.id == user.employee.current_assignment.store.id
			end
			can :read, Employee do |employee|
				employee.current_assignment.store.id == user.employee.current_assignment.store.id
			end
			can :read, Store
			can :read, Shift
			can :create, Shift
			can :update, Shift do |shift|
				shift.assignment.store.id == user.employee.current_assignment.store.id
			end
			can :destroy, Shift do |shift|
				shift.assignment.store.id == user.employee.current_assignment.store.id
			end
			can :create, ShiftJob
			can :update, ShiftJob
		elsif user.role == 'employee'
			can :read, Store
			can :read, Employee do |employee|
				employee.id == user.employee.id
			end
		elsif
			can :read, Store
		end
	end
end
			