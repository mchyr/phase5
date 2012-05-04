namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    # Invoke rake db:migrate just in case...
    Rake::Task['db:migrate'].invoke
    
    # Need two gems to make this work: faker & populator
    # Docs at: http://populator.rubyforge.org/
    require 'populator'
    # Docs at: http://faker.rubyforge.org/rdoc/
    require 'faker'
    
    # Step 0: clear any old data in the db
    [Employee, Assignment, Store, Shift, User, Job, ShiftJob].each(&:delete_all)
    
    # Step 1a: Add Alex as admin and user
    ae = Employee.new
    ae.first_name = "Alex"
    ae.last_name = "Heimann"
    ae.ssn = "123456789"
    ae.date_of_birth = "1993-01-25"
    ae.phone = "412-268-3259"
    ae.role = "admin"
    ae.active = true
    ae.save!
    au = User.new
    au.email = "alex@example.com"
    au.password = "creamery"
    au.password_confirmation = "creamery"
    au.employee_id = ae.id
    au.save!
    
    # Step 1b: Add Mark as employee and user
    me = Employee.new
    me.first_name = "Mark"
    me.last_name = "Heimann"
    me.ssn = "987654321"
    me.date_of_birth = "1993-01-25"
    me.phone = "412-268-8211"
    me.active = true
    me.role = "admin"
    me.save!
    mu = User.new
    mu.email = "mark@example.com"
    mu.password = "creamery"
    mu.password_confirmation = "creamery"
    mu.employee_id = me.id
    mu.save!
    
    # Step 1c: Add Rachel as employee and user
    re = Employee.new
    re.first_name = "Rachel"
    re.last_name = "Heimann"
    re.ssn = "013125299"
    re.date_of_birth = "1993-01-25"
    re.phone = "412-268-8211"
    re.active = true
    re.role = "manager"
    re.save!
    ru = User.new
    ru.email = "rachel@example.com"
    ru.password = "creamery"
    ru.password_confirmation = "creamery"
    ru.employee_id = re.id
    ru.save!
    
    # Step 1c: Add Dusty as employee and user
    de = Employee.new
    de.first_name = "Dusty"
    de.last_name = "Heimann"
    de.ssn = "310521992"
    de.date_of_birth = "1993-01-25"
    de.phone = "412-268-8211"
    de.active = true
    de.role = "employee"
    de.save!
    du = User.new
    du.email = "dusty@example.com"
    du.password = "creamery"
    du.password_confirmation = "creamery"
    du.employee_id = de.id
    du.save!
    
    # Step 2: Add some stores
    stores = {"Carnegie Mellon" => "5000 Forbes Avenue;15213", "Convention Center" => "1000 Fort Duquesne Blvd;15222", "Point State Park" => "101 Commonwealth Place;15222"}
    stores.each do |store|
      str = Store.new
      str.name = store[0]
      street, zip = store[1].split(";")
      str.street = street
      str.city = "Pittsburgh"
      str.zip = zip
      str.phone = rand(10 ** 10).to_s.rjust(10,'0')
      str.active = true
      str.save!
    end
    
    # Step 3a: Add two managers for each store
    active_stores = Store.active.each do |store|
      # Add manager 
      2.times do |i|
        mgr = Employee.new
        mgr.first_name = Faker::Name.first_name
        mgr.last_name = Faker::Name.last_name
        mgr.ssn = rand(9 ** 9).to_s.rjust(9,'0')
        mgr.date_of_birth = (rand(9)+20).years.ago.to_date
        mgr.phone = rand(10 ** 10).to_s.rjust(10,'0')
        mgr.active = true
        mgr.role = "manager"
        mgr.save!
        # Assign to store
        assign_mgr = Assignment.new
        assign_mgr.store_id = store.id
        assign_mgr.employee_id = mgr.id
        assign_mgr.start_date = (rand(14)+2).months.ago.to_date
        assign_mgr.end_date = nil
        assign_mgr.pay_level = [4,5].sample
        assign_mgr.save!
      end
    end
    
    # Step 3b: Assign Rachel as a manager to the first store
    first_store = Store.active.first
    assign_rachel = Assignment.new
    assign_rachel.store_id = first_store.id
    assign_rachel.employee_id = re.id
    assign_rachel.start_date = (rand(14)+2).months.ago.to_date
    assign_rachel.end_date = nil
    assign_rachel.pay_level = 5
    assign_rachel.save!
    
    # Step 3c: Assign Dusty as an employee to the first store
    assign_dusty = Assignment.new
    assign_dusty.store_id = first_store.id
    assign_dusty.employee_id = de.id
    assign_dusty.start_date = (rand(6)+1).months.ago.to_date
    assign_dusty.end_date = nil
    assign_dusty.pay_level = 2
    assign_dusty.save!
    
    # Step 4: Add some other employees to the system
    store_ids = Store.all.map(&:id)
    Employee.populate 100 do |employee|
      # get some fake data using the Faker gem
      employee.first_name = Faker::Name.first_name
      employee.last_name = Faker::Name.last_name
      employee.role = "employee"
      employee.ssn = rand(9 ** 9).to_s.rjust(9,'0')
      employee.phone = rand(10 ** 10).to_s.rjust(10,'0')
      employee.date_of_birth = 22.years.ago..15.years.ago
      not_active = rand(5)
      if not_active.zero?
        employee.active = false
      else
        employee.active = true
      end
      employee.created_at = Time.now
      employee.updated_at = Time.now
      
      # Step 5: Add an assignment for each employee
      pay_levels = [1,2,3]
      Assignment.populate 1 do |asn1|
        asn1.employee_id = employee.id
        asn1.store_id = store_ids.sample 
        asn1.pay_level = pay_levels.sample 
        asn1.start_date = 2.years.ago..3.months.ago
        if employee.active
          asn1.end_date = nil
        else
          asn1.end_date = 2.months.ago..2.days.ago
        end
      end
    end
    
    # Step 6: Add another assignment for some employees
    current_assignments = Assignment.current.for_role("employee").all
    current_assignments.each do |first_assignment|
      additional_assignments = rand(4)
      unless additional_assignments.zero?
        number_of = (2..49).to_a.sample
        asn2 = Assignment.new
          asn2.employee_id = first_assignment.employee_id
          asn2.store_id = store_ids.sample
          asn2.pay_level = first_assignment.pay_level + 1
          asn2.start_date = number_of.days.ago
          asn2.end_date = nil
        asn2.save!
      end
    end
    
    # Step 7: Add some jobs
    jobs = %w[Cashier Mopping Make\ ice\ cream ]
    jobs.each do |j|
      job = Job.new
      job.name = j
      job.description = "Best job ever"
      job.active = true
      job.save!
    end
    
    # Step 8: Add some shifts to current assignments
    current_assignments = Assignment.current.for_role("employee").all
    current_assignments.each do |assignment|
      shift1 = Shift.new
      shift1.assignment_id = assignment.id
      # number_of = (6..12).to_a.sample
      shift1.date = assignment.start_date + 1
      start_hour = (11..18).to_a.sample
      shift1.start_time = Time.local(2000,1,1,start_hour,0,0)
      shift1.save!
      
      additional_shifts = rand(4)
      unless additional_shifts.zero?
        shift2 = Shift.new
        shift2.assignment_id = assignment.id
        # number_of = (2..5).to_a.sample
        shift2.date = assignment.start_date + 2
        start_hour = (11..18).to_a.sample
        shift2.start_time = Time.local(2000,1,1,start_hour,0,0)
        shift2.save!
      end
    end
  end
end