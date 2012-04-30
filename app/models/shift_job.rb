class ShiftJob < ActiveRecord::Base
  #before_save :not_during_shift
  # Relationships
  belongs_to :shift
  belongs_to :job
  
  # Validation
  validate :only_jobs_that_are_active

  scope :for_job, lambda {|job_id| where("job_id = ?", job_id)}
  scope :for_shift, lambda {|shift_id| where("shift_id =?", shift_id)}
  scope :by_job, order('job_id')
  scope :by_shift, order('shift_id')
  
  private
  def only_jobs_that_are_active
    all_active_jobs = Job.active.all.map{|j| j.id}
    unless all_active_jobs.include?(self.job_id)
      errors.add(:job_id, "is not an active job at the creamery")
    end
  end
  
end
