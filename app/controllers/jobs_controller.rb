class JobsController < ApplicationController
	before_filter :check_login, :except => [:show, :index, :new, :edit, :create, :update, :delete]

  	def index
    	@jobs = Job.active.paginate(:page => params[:page]).per_page(10)
    	@inactive_jobs = Job.inactive.paginate(:page => params[:page]).per_page(10)
  	end

	def show
		@job = Job.find(paams[:id])
		authorize! :show, @job
	end

	def new
		@job = Job.new
		authorize! :new, @job
	end

	def edit
		@job = Job.find(params[:id])
		@authorize! :edit, @job
	end

	def create
		@job = Job.new(params[:job])
		authorize! :create, @job
		respond_to do |format|
			if @job.save
				format.html {redirect_to @job, notice: 'Job was successfully created.'}
				format.json {render json: @job, status: :created, location: @job}
			else
				format.html {render action: "new"}
				format.json {render json: @job.errors, status: :unprocessable_entity}
			end
		end
	end

	def update
		@job = Job.find(params[:id])
		authorize! :update, @job
		respond_to do |format|
			if @job.update_attributes(params[:job])
				format.html {redirect_to @job, notice: 'Job was successfully updated.'}
				format.json {head :no_content}
			else
				format.html {render action: "edit"}
				format.json {render json: @job.errors, status: :unprocessable_entity}
			end
		end
	end

	def destroy
		@job = Job.find(params[:id])
		authorize! :destroy, @job
		@job.destroy

		respond_to do |format|
			format.html {redirect_to jobs_url, notice: 'Job was successfully deleted.'}
			format.json {head :no_content}
		end
	end
	
end

