class User < ActiveRecord::Base
  #attr_accessible :email, :password, :password_confirmation, :employee_id
  #attr_accessor :password
  #before_save :prepare_password

  # Relationship
  belongs_to :employee
  
  # Validations
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))$/i, :message => "is not a valid format"
  validate :employee_is_active_in_system

  #validates_presence_of :password, :on => :create
  #validates_confirmation_of :password
  #validates_length_of :password, :minimum => 4, :allow_blank => true

  # #def proper_name
  #   Employee.find(self.employee_id).proper_name
  # end

  # def role
  #   if self.employee_id.blank?
  #     return 'guest'
  #   end
  #   Employee.find(self.employee_id).role
  # end

  # def role? (authorized_role)
  #   return false if self.role.nil?
  #   self.role == authorized_role
  # end

  # def send_password_reset
  #   generate_token(:password_reset_token)
  #   self.password_reset_sent_at = Time.now
  #   save!
  #   UserMailer.password_reset(self).deliver
  # end

  # def generate_token(column)
  #   begin
  #     self[column] = SecureRandom.urlsafe_base64
  #   end while User.exists?(column => self[column])
  # end

  # def self.authenticate(login, pass)
  #   user = find_by_email(login)
  #   return user if user && user.password_hash == user.encrypt_password(pass)
  # end

  # def encrypt_password(pass)
  #   BCrypt::Engine.hash_secret(pass, password_salt)
  # end
  
  private
  def employee_is_active_in_system
    all_active_employees = Employee.active.all.map{|e| e.id}
    unless all_active_employees.include?(self.employee_id)
      errors.add(:employee_id, "is not an active employee at the creamery")
    end
  end

  # def prepare_password
  #   unless password.blank?
  #     self.password_salt = BCrypt::Engine.generate_salt
  #     self.password_hash = encrypt_password(password)
  #   end
  # end
  
end
