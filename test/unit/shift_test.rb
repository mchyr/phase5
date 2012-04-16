require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:assignment)
  should have_many(:shift_jobs)
  should have_many(:jobs).through(:shift_jobs)
  should have_one(:employee).through(:assignment)
  should have_one(:store).through(:assignment)
  
  # Test values for assignment_id
  should allow_value(17).for(:assignment_id)
  should allow_value(1000001).for(:assignment_id)
  should_not allow_value("bad").for(:assignment_id)
  should_not allow_value(-19).for(:assignment_id)
  should_not allow_value(3.14159).for(:assignment_id)
  should_not allow_value(nil).for(:assignment_id)
  
  # Establish context
  context "Creating a context" do
    setup do 
      @cmu = FactoryGirl.create(:store)
      @oakland = FactoryGirl.create(:store, :name => "Oakland", :street => "Fifth Avenue")
      
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
      @assign_cindy = FactoryGirl.create(:assignment, :employee => @cindy, :store => @cmu, :start_date => 14.months.ago.to_date, :end_date => nil)
      @shift_cindy = FactoryGirl.create(:shift, :assignment => @assign_cindy, :date => 1.day.from_now.to_date)
      
      @ben = FactoryGirl.create(:employee, :first_name => "Ben", :last_name => "Sisko", :role => "manager", :phone => "412-268-2323")
      @assign_ben = FactoryGirl.create(:assignment, :employee => @ben, :store => @cmu, :start_date => 2.years.ago.to_date, :end_date => 6.months.ago.to_date, :pay_level => 3)
      
      @kathryn = FactoryGirl.create(:employee, :first_name => "Kathryn", :last_name => "Janeway", :role => "manager", :date_of_birth => 30.years.ago.to_date)
      @assign_kathryn = FactoryGirl.create(:assignment, :employee => @kathryn, :store => @oakland, :start_date => 10.months.ago.to_date, :end_date => nil, :pay_level => 3)
      @shift_kathryn = FactoryGirl.create(:shift, :assignment => @assign_kathryn)
      @cashier = FactoryGirl.create(:job)
      @mopping = FactoryGirl.create(:job, :name => "Mopping")
      @sj_kath_cashier = FactoryGirl.create(:shift_job, :shift => @shift_kathryn, :job => @cashier)
      
      @ralph = FactoryGirl.create(:employee, :first_name => "Ralph", :last_name => "Wilson", :date_of_birth => 17.years.ago.to_date)
      @assign_ralph = FactoryGirl.create(:assignment, :employee => @ralph, :store => @oakland, :start_date => 10.months.ago.to_date, :end_date => nil, :pay_level => 3)
      @shift_ralph_1 = FactoryGirl.create(:shift, :assignment => @assign_ralph, :date => 3.days.ago.to_date)
      @shift_ralph_2 = FactoryGirl.create(:shift, :assignment => @assign_ralph, :date => 2.days.ago.to_date, :start_time => Time.local(2000,1,1,12,0,0,), :end_time => Time.local(2000,1,1,16,0,0,))
      @shift_ralph_3 = FactoryGirl.create(:shift, :assignment => @assign_ralph, :date => 1.day.ago.to_date, :start_time => Time.local(2000,1,1,13,0,0,), :end_time => Time.local(2000,1,1,14,0,0,))
      @shift_ralph_4 = FactoryGirl.create(:shift, :assignment => @assign_ralph, :date => Date.today, :start_time => Time.local(2000,1,1,13,0,0,))
      @sj_ralph_cashier = FactoryGirl.create(:shift_job, :shift => @shift_ralph_1, :job => @cashier)
      @sj_ralph_cashier2 = FactoryGirl.create(:shift_job, :shift => @shift_ralph_2, :job => @cashier)
      @sj_ralph_mopping = FactoryGirl.create(:shift_job, :shift => @shift_ralph_2, :job => @mopping)
      
      @ed = FactoryGirl.create(:employee)
      @assign_ed = FactoryGirl.create(:assignment, :employee => @ed, :store => @cmu, :end_date => nil)
      @shift_ed = FactoryGirl.create(:shift, :assignment => @assign_ed, :date => 4.days.from_now.to_date)
    end
    
    teardown do
      @cmu.destroy
      @oakland.destroy
      
      @cindy.destroy
      @assign_cindy.destroy
      @shift_cindy.destroy
      
      @ben.destroy
      @assign_ben.destroy
      
      @kathryn.destroy
      @assign_kathryn.destroy
      @shift_kathryn.destroy
      @cashier.destroy
      @sj_kath_cashier.destroy
      
      @ralph.destroy
      @assign_ralph.destroy
      @shift_ralph_1.destroy
      @shift_ralph_2.destroy
      @shift_ralph_3.destroy
      @shift_ralph_4.destroy
      @sj_ralph_cashier.destroy
      @sj_ralph_cashier2.destroy
      @sj_ralph_mopping.destroy
      
      @ed.destroy
      @assign_ed.destroy
      @shift_ed.destroy    
    end
  
    # now run the tests:
    # first, verify the factory for shift is working properly...
    should "show that the shift factories are properly created" do
      assert_equal "Oakland", @shift_kathryn.store.name
      assert_equal "Janeway, Kathryn", @shift_kathryn.employee.name
      assert_equal "This was a great shift and enjoyed by all who chose to partake.", @shift_kathryn.notes
      assert_equal Date.today, @shift_kathryn.date
      assert_equal "11:00:00", @shift_kathryn.start_time.strftime("%H:%M:%S")
      assert_equal "14:00:00", @shift_kathryn.end_time.strftime("%H:%M:%S")
      assert_not_equal "12:00:00", @shift_kathryn.start_time.strftime("%H:%M:%S")
      assert_not_equal "00:00:00", @shift_kathryn.start_time.strftime("%H:%M:%S")
      assert_not_equal Time.now.strftime("%H:%M:%S"), @shift_kathryn.start_time.strftime("%H:%M:%S")
    end
    
    # test validations
    should "only accept date data for date field" do
      @shift_kj_bad = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :date => "FRED")
      deny @shift_kj_bad.valid?
      @shift_kj_bad2 = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :date => "14:00:00")
      deny @shift_kj_bad2.valid?
      @shift_kj_bad3 = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :date => 2011)
      deny @shift_kj_bad3.valid?
      @shift_kj_good = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :date => 2.weeks.ago.to_date)
      assert @shift_kj_good.valid?
    end
    
    should "not allow date to be nil" do
      @shift_kj_bad = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :date => nil)
      deny @shift_kj_bad.valid?
    end
    
    should "ensure that shift dates do not precede the assignment start date" do
      @shift_kj_bad = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :date => 2.years.ago.to_date)
      deny @shift_kj_bad.valid?
      @shift_kj_good = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :date => 2.weeks.ago.to_date)
      assert @shift_kj_good.valid?
    end
    
    should "only accept time data for start time" do 
      # KNOWN BUG: see https://github.com/adzap/validates_timeliness/issues/52
      # @shift_kj_bad = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :start_time => "FRED")
      # deny @shift_kj_bad.valid?
      @shift_kj_bad2 = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :start_time => "12:66")
      deny @shift_kj_bad2.valid?
      @shift_kj_bad3 = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :start_time => 2011)
      deny @shift_kj_bad3.valid?
      @shift_kj_good = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :start_time => Time.local(2000,1,1,12,0,0))
      assert @shift_kj_good.valid?
    end
    
    should "only accept time data for end time" do 
      # KNOWN BUG: see https://github.com/adzap/validates_timeliness/issues/52
      # @shift_kj_bad = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :end_time => "FRED")
      # deny @shift_kj_bad.valid?
      # @shift_kj_bad2 = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :end_time => "12:66")
      # deny @shift_kj_bad2.valid?
      @shift_kj_bad3 = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :end_time => 2011)
      deny @shift_kj_bad3.valid?
      @shift_kj_good = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :start_time => Time.local(2000,1,1,12,0,0), :end_time => Time.local(2000,1,1,16,0,0))
      assert @shift_kj_good.valid?
    end
    
    should "not allow start time to be nil" do
      @shift_kj_bad = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :start_time => nil)
      deny @shift_kj_bad.valid?
    end
    
    should "allow end time can be nil" do
      @shift_kj_good = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :end_time => nil)
      assert @shift_kj_good.valid?
    end
    
    should "ensure that shift end times do not precede the shift start time" do
      @shift_kj_bad = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :end_time => Time.local(2000,1,1,10,0,0))
      deny @shift_kj_bad.valid?
      @shift_kj_good = FactoryGirl.build(:shift, :assignment => @assign_kathryn, :end_time => Time.local(2000,1,1,14,0,0))
      assert @shift_kj_good.valid?
    end
    
    should "ensure that shift are only given to current assignments" do
      @shift_ben_bad = FactoryGirl.build(:shift, :assignment => @assign_ben)
      deny @shift_ben_bad.valid?
      @shift_kj_good = FactoryGirl.build(:shift, :assignment => @assign_kathryn)
      assert @shift_kj_good.valid?
    end
    
    # test completed? method
    should "have a completed? method that works properly" do
      deny @shift_cindy.completed?
      assert @shift_kathryn.completed?
    end
    
    # test callback to see that end_time is set to 3 hours afterwards
    should "have a callback which sets end time to three hours on create, but not on update" do
      # end_time is set on create
      @shift_kj_good = FactoryGirl.create(:shift, :assignment => @assign_kathryn, :start_time => Time.local(2000,1,1,14,0,0), :end_time => nil)
      assert_equal "17:00:00", @shift_kj_good.end_time.strftime("%H:%M:%S")
      # end_time is left alone on update
      assert_equal "14:00:00", @shift_kathryn.end_time.strftime("%H:%M:%S")
      @shift_kathryn.notes = "She did a good job today."
      @shift_kathryn.start_time = Time.local(2000,1,1,12,0,0)
      @shift_kathryn.save!
      assert_equal "14:00:00", @shift_kathryn.end_time.strftime("%H:%M:%S")
    end
    
    # test scopes
    should "have a scope for completed shifts" do
      assert_equal 3, Shift.completed.all.size
    end
    
    should "have a scope for incomplete shifts" do
      assert_equal 4, Shift.incomplete.all.size
    end
    
    should "have a scope called for_store" do
      assert_equal 2, Shift.for_store(@cmu.id).size
      assert_equal 5, Shift.for_store(@oakland.id).size
    end
    
    should "have a scope called for_employee" do
      assert_equal 4, Shift.for_employee(@ralph.id).size
      assert_equal 1, Shift.for_employee(@cindy.id).size
      assert_equal 1, Shift.for_employee(@ed.id).size
      assert_equal 1, Shift.for_employee(@kathryn.id).size
    end
    
    should "have a scope for past shifts" do
      assert_equal 3, Shift.past.size
    end
    
    should "have a scope for upcoming shifts" do
      assert_equal 4, Shift.upcoming.size
    end
    
    should "have a scope called for_next_days" do
      assert_equal 2, Shift.for_next_days(0).size
      assert_equal 3, Shift.for_next_days(2).size
      assert_equal 4, Shift.for_next_days(7).size
    end
    
    should "have a scope called for_past_days" do
      assert_equal 1, Shift.for_past_days(1).size
      assert_equal 2, Shift.for_past_days(2).size
      assert_equal 3, Shift.for_past_days(3).size
    end
    
    should "have a scope to order chronologically" do
      assert_equal ['Ralph','Ralph','Ralph','Kathryn','Ralph','Cindy','Ed'], Shift.chronological.map{|s| s.employee.first_name}
    end

    should "have a scope to order by store name" do
      assert_equal ['CMU','CMU','Oakland','Oakland','Oakland','Oakland','Oakland'], Shift.by_store.map{|s| s.store.name}
    end
    
    should "have a scope to order by employee name" do
      assert_equal ['Crawford, Cindy','Gruberman, Ed','Janeway, Kathryn','Wilson, Ralph','Wilson, Ralph','Wilson, Ralph','Wilson, Ralph'], Shift.by_employee.map{|s| s.employee.name}
    end
    
  end
end
