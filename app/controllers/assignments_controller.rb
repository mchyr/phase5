class AssignmentsController < ApplicationController

  before_filder :check_login
  authorize_resource

  def index
    @assignments = Assignment.current.by_store.by_employee.chronological.paginate(:page => params[:page]).per_page(15)
    @past_assignments = Assignment.past.by_employee.by_store.paginate(:page => params[:page]).per_page(15)
  end

  def show
    @assignment = Assignment.find(params[:id])
    # get the shift history for this assignment (later; empty now)
    @shifts = Array.new
  end

  def new
    if params[:from].nil?
      if params[:id].nil?
        @assignment = Assignment.new
      else
        @assignment = Assignment.find(params[:id])
      end
    else
      @assignment = Assignment.new
      if params[:from] == "store" 
        @assignment.store_id = params[:id]
      else
        @assignment.employee_id = params[:id]
      end
    end
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def create
    @assignment = Assignment.new(params[:assignment])
    if @assignment.save
      # if saved to database
      flash[:notice] = "#{@assignment.employee.proper_name} is assigned to #{@assignment.store.name}."
      redirect_to @assignment # go to show assignment page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = "#{@assignment.employee.proper_name}'s assignment to #{@assignment.store.name} is updated."
      redirect_to @assignment
    else
      render :action => 'edit'
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy
    flash[:notice] = "Successfully removed #{@assignment.employee.proper_name} from #{@assignment.store.name}."
    redirect_to assignments_url
  end
end
