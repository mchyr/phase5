class AssignmentsController < ApplicationController

  before_filter :check_login
  authorize_resource

  def index
    @assignment = Assignment.current.by_store.by_employee.chronological.paginate(:page => params[:page]).per_page(10)
    @past_assignments = Assignment.past.by_employee.by_store.paginate(:page => params[:past_page]).per_page(10)
  end

  def show
    @assignment = Assignment.find(params[:id])
    # get the shift history for this assignment (later; empty now)
    @current_assignment = Assignment.current
  end

  def new
    @assignment = Assignment.new
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def create
    @assignment = Assignment.new(params[:assignment])
    if @assignment.save
      # if saved to database
      flash[:notice] = "Successfully created #{@assignment.id}."
      redirect_to @assignment # go to show assignment page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = "Successfully updated #{assignment.id}"
      redirect_to @assignment
    else
      render :action => 'edit'
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy
    flash[:notice] = "Successfully ended #{(@assignment.employee).proper_name}'s assignment from #{(@assignment.store).name}."
    redirect_to assignments_url
  end
end
