class ShiftJob < ActiveRecord::Base
  # Relationships
  belongs_to :shift
  belongs_to :job
  
  # Validation
  validate :only_jobs_that_are_active
  
  private
  def only_jobs_that_are_active
    all_active_jobs = Job.active.all.map{|j| j.id}
    unless all_active_jobs.include?(self.job_id)
      errors.add(:job_id, "is not an active job at the creamery")
    end
  end
  
end
