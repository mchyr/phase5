class ShiftsController < ApplicationController
  # GET /shifts
  # GET /shifts.json
  def index
    @shifts = Shift.paginate(:page => params[:page]).per_page(10)
    if (current_user.role == 'manager')
    	@shifts = Shift.for_store(current_user.employee.current_assignment.store.id).chronological.paginate(:page => params[:page]).per_page(10)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shifts }
    end
  end

  # GET /shifts/1
  # GET /shifts/1.json
  def show
    @shift = Shift.find(params[:id])
    authorize! :read, @shift
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shift }
    end
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
    authorize! :create, @shift
    @shift.shift_jobs.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shift }
    end
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
    authorize! :update, @shift
    @jobs = Job.active.all

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
    authorize! :destroy, @shift
    respond_to do |format|
    	if current_user.role == 'manager'
    		if has_incomplete_shifts?
    			format.html {redirect_to manager_incomplete_path}
    		else
    			format.html {redirect_to manager_dash_path}
    		end
    	else
    		format.html {redirect_to shifts_url}
    	end
    	format.json {head :no_content}
    end
  end
end
