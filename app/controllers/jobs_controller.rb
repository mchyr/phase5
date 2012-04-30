class JobsController < ApplicationController
	before_filter :check_login
	authorize_resource

	def index
		@jobs = Job.active.paginate(:page => params[:page]).per_page(10)
		respond_to do |format|
			format.html # @index.html.erb
			format.json {render json: @jobs}
		end
	end

	def index_inactive
		@inactive_jobs = Job.inactive.paginate(:page => params[:page]).per_page(10)
	end

	def show
		@job = Job.find(paragms[:id])
		respond_to do |format|
			format.html # @show.html.erb
			format.json {render json: @job}
		end
	end

	def new
		@job = Job.new
		respond_to do |format|
			format.html # @new.html.erb
			format.json {render json: @job}
		end
	end

	def edit
		@job = Job.find(params[:id])
	end

	def create
		@job = Job.new(params[:job])
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
		@job.destroy

		respond_to do |format|
			format.html {redirect_to jobs_url}
			format.json {head :no_content}
		end
	end
end
