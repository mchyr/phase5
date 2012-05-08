class EmployeesController < ApplicationController

  before_filter :check_login

  def index
    if current_user.role == 'admin'
      @employees = Employee.active.alphabetical.paginate(:page => params[:page]).per_page(10)
      @past_employees = Employee.inactive.alphabetical.paginate(:page => params[:inactive_page]).per_page(10)
    elsif current_user.role == 'manager'
      @employees = current_user.employee.current_assignment.store.assignments.current.by_employee.paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
    @employee = Employee.find(params[:id])
    @current_assignment = @employee.current_assignment
    # get the assignment history for this employee
    @assignments = @employee.assignments.chronological.paginate(:page => params[:page]).per_page(10)
    # get upcoming shifts for this employee (later)
    @shifts = Shift.for_employee(@employee.id).for_next_days(10).chronological
    @shifts_past = Shift.past.for_employee(@employee.id).chronological
    authorize! :show, @employee
  end

  def new
    @employee = Employee.new
  end

  def edit
    @employee = Employee.find(params[:id])
    authorize! :update, @employee
  end

  def create
    @employee = Employee.new(params[:employee])
    if @employee.save
      # if saved to database
      flash[:notice] = "Successfully created #{@employee.proper_name}."
      redirect_to @employee # go to show employee page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @employee = Employee.find(params[:id])
    authorize! :update, @employee
    if @employee.update_attributes(params[:employee])
      flash[:notice] = "Successfully updated #{@employee.proper_name}."
      redirect_to @employee
    else
      render :action => 'edit'
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    flash[:notice] = "Successfully removed #{@employee.proper_name} from the Creamery system."
    redirect_to employees_url
  end
end
