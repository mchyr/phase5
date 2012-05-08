class HomeController < ApplicationController
  before_filter :check_login, :except => [:index, :about, :contact, :privacy, :store_location]

  def index
    @stores = Store.active.alphabetical
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def store_locations
    @stores = Store.active.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def search
    @query = params[:query]
    @employees = Employee.search(@query)
    @stores = Store.search(@query)
    @total_hits = @employees.size + @stores.size
  end

  def admin
    if current_user.role != "admin"
      @stores = Store.active.alphabetical.paginate(:page => params[:page]).per_page(10)
      @top_employees = Employee.active.sort{|x,y| x.worked_hours_over_past_few_days <=> y.worked_hours_over_past_few_days}.reverse.first(5)
    else
      redirect_to root_url, notice: "You must be an admin to view this page."
    end
  end

  def manager
    if current_user.role != "manager"
      @employee = Employee.find(current_user.employee_id)
      @store = Store.find(@employee.current_assignment.store_id)
      @assignments = Assignment.for_store(@store.id).current.paginate(:page => params[:page]).per_page(10)
      unless @employee.curent_assignment.nil?
        @current_assignments = @employee.current_assignment.store.assignments.current.by_employee.paginate(:page => params[:current_assignments]).per_page(10)
        @today_shifts = Shift.for_store(@employee.current_assignment.store).fo_next_days(0).paginate(:page => params[:today_shifts]).per_page(10)
        @incomplete_shifts = Shift.for_store(@employee.current_assignment.store).past.incomplete.chronological.paginate(:page => params[:incomplete_shifts]).per_page(10)
      end
    else
      redirect_to root_url, notice: "You must be a manager to view this page."
    end
  end

  # def manager_shifts
  #   if current_user.role != "manager"
  #     redirect_to root_url, notice: "You must be a manager to view this page."
  #   end
  #   @employee = Employee.find(current_user.employee_id)
  #   @store = Store.find(@employee.current_assignment.store_id)
  #   @assignments = Assignment.for_store(@store.id).paginate(:page => params[:page]).per_page(10)
  #   @todays_shifts = Shift.for_store(@store.id).for_next_days(0).chronological.paginate(:page => params[:page]).per_page(10)
  # end

  def manager_incomplete
    @employee = Employee.find(current_user.employee_id)
    @store = Store.find(@employee.current_assignment.store_id)
    @incomplete_shifts = Shift.for_store(@employee.current_assignment.store).past.incomplete.chronological.paginate(:page => params[:incomplete_shifts]).per_page(10)
    @current_assignments = @employee.current_assignment.store.assignments.current.by_employee.paginate(:page => params[:current_assignments]).per_page(10)
  end

  # def manager_unfilled
  #   if current_user.role != "manager"
  #     redirect_to root_url, notice: "You must be a manager to view this page."
  #   end
  #   @employee = Employee.find(current_user.employee_id)
  #   @store = Store.find(@employee.current_assignment.store_id)
  #   @assignments = Assignment.for_stire(@store.id).paginate(:page => params[:page]).per_page(10)
  #   @unfilled_hours = @store.get_unworked_hours_for_week
  # end

  def employee
    @employee = current_user.employee
    @past_shifts = Shift.past.for_employee(@employee.id).paginate(:page => params[:pasts_page]).per_page(10)
    @shifts = Shift.for_employee(@employee.id).for_next_days(14).paginate(:page => params[:shifts_page]).per_page(10)
  end

end