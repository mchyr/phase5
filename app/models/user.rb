class User < ActiveRecord::Base
  # Relationship
  belongs_to :employee
  
  # Validations
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))$/i, :message => "is not a valid format"
  validate :employee_is_active_in_system
  
  private
  def employee_is_active_in_system
    all_active_employees = Employee.active.all.map{|e| e.id}
    unless all_active_employees.include?(self.employee_id)
      errors.add(:employee_id, "is not an active employee at the creamery")
    end
  end
  
end
