class Job < ActiveRecord::Base
  # Relationships
  has_many :shift_jobs
  has_many :shifts, :through => :shift_jobs
  
  # Validations
  validates_presence_of :name
  
  # Scopes
  scope :alphabetical, order('name')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  
end
