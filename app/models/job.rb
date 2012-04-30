class Job < ActiveRecord::Base
	# before_destroy :make_inactive

 	# Relationships
	has_many :shift_jobs
	has_many :shifts, :through => :shift_jobs
  
	# Validations
	validates_presence_of :name
  
	# Scopes
	scope :alphabetical, order('name')
	scope :active, where('active = ?', true)
	scope :inactive, where('active = ?', false)

	# def associated_with_shift(shift_id)
	# 	self.shift_jobs.each do |shift_job|
	# 		if shift_job.job_id == self.id && shift_job.shift_id == shift_id
	# 			return false
	# 		end
	# 	end
	# 	return true
	# end

	# def make_inactive
	# 	update_attributes(:active, false) and return false
	# end
end
