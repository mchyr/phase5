class ShiftJobsController < ApplicationController

  before_filter :check_login
  authorize_resource
  
  # GET /shift_jobs
  # GET /shift_jobs.json
  def index
    @shift_jobs = ShiftJob.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shift_jobs }
    end
  end

  # GET /shift_jobs/1
  # GET /shift_jobs/1.json
  def show
    @shift_job = ShiftJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shift_job }
    end
  end

  # GET /shift_jobs/new
  # GET /shift_jobs/new.json
  def new
    @shift_job = ShiftJob.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shift_job }
    end
  end

  # GET /shift_jobs/1/edit
  def edit
    @shift_job = ShiftJob.find(params[:id])
  end

  # POST /shift_jobs
  # POST /shift_jobs.json
  def create
    @shift_job = ShiftJob.new(params[:shift_job])

    respond_to do |format|
      if @shift_job.save
        format.html { redirect_to @shift_job, notice: 'Shift job was successfully created.' }
        format.json { render json: @shift_job, status: :created, location: @shift_job }
      else
        format.html { render action: "new" }
        format.json { render json: @shift_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shift_jobs/1
  # PUT /shift_jobs/1.json
  def update
    @shift_job = ShiftJob.find(params[:id])

    respond_to do |format|
      if @shift_job.update_attributes(params[:shift_job])
        format.html { redirect_to @shift_job, notice: 'Shift job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shift_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shift_jobs/1
  # DELETE /shift_jobs/1.json
  def destroy
    @shift_job = ShiftJob.find(params[:id])
    @shift_job.destroy

    respond_to do |format|
      format.html { redirect_to shift_jobs_url }
      format.json { head :no_content }
    end
  end
end
