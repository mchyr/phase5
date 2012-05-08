class ShiftsController < ApplicationController

  before_filter :check_login

  # GET /shifts
  # GET /shifts.json
  def index
    @employee = current_user.employee
    if current_user.role == 'admin'
      @shifts = Shift.completed.chronological.by_employee.paginate(:page => params[:page]).per_page(10)
      @incomplete_shifts = Shift.past.incomplete.chronological.paginate(:page => params[:incomplete_shifts]).per_page(10)
    elsif current_user.role == 'manager'
      @shifts = Shift.for_store(@employee.current_assignment.store).completed.chronological.by_employee.paginate(:page => params[:page]).per_page(10)
      @incomplete_shifts = Shift.for_store(@employee.current_assignment.store).past.incomplete.chronological.paginate(:page => params[:incomplete_shifts]).per_page(10)
  end

  # GET /shifts/1
  # GET /shifts/1.json
  def show
    @shift = Shift.find(params[:id])
    authorize! :show, @shift
  end

  # GET /shifts/new
  # GET /shifts/new.json
  def new
    if params[:assignment_id]
      @shift = Shift.new(:assignment_id => params[:assignment_id])
    elsif params[:date] && params[:start_time]
      @shift = Shift.new(:date => params[:date], :start_time => params[:start_time])
    else
      @shift = Shift.new
    end
    @shift.shift_jobs.build
    authorize! :create, @shift
  end

  # GET /shifts/1/edit
  def edit
    @shift = Shift.find(params[:id])
    @jobs = Job.active.alphabetical.all
    @shift_jobs = @shift.jobs
  end

  # POST /shifts
  # POST /shifts.json
  def create
    @shift = Shift.new(params[:shift])
    authorize! :create, @shift
    respond_to do |format|
      if @shift.save
        format.html { redirect_to @shift, notice: 'Shift was successfully created.' }
        format.json { render json: @shift, status: :created, location: @shift }
      else
        format.html { render action: "new" }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shifts/1
  # PUT /shifts/1.json
  def update
    @shift = Shift.find(params[:id])
    @jobs = Job.active.all
    authorize! :update, @shift

    respond_to do |format|
      if @shift.update_attributes(params[:shift])
        format.html { redirect_to @shift, notice: 'Shift was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shifts/1
  # DELETE /shifts/1.json
  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy

    respond_to do |format|
      if current_user.role == 'manager'
        format.html {redirect_to manager_dash_path}
      else
        format.html {redirect_to shifts_url}
      end
      format.json {head :no_content}
    end
  end
end
