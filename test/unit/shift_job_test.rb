require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:shift)
  should belong_to(:job)
  
  # Establish context
  context "Creating a context" do
    setup do 
      @cashier = FactoryGirl.create(:job)
      @mopping = FactoryGirl.create(:job, :name => "Mopping")
      @making = FactoryGirl.create(:job, :name => "Ice cream making")
      @mover = FactoryGirl.create(:job, :name => "Mover", :active => false)
      
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
      @sj_kath_cashier = FactoryGirl.create(:shift_job, :shift => @shift_kathryn, :job => @cashier)
      
      @ralph = FactoryGirl.create(:employee, :first_name => "Ralph", :last_name => "Wilson", :date_of_birth => 17.years.ago.to_date)
      @assign_ralph = FactoryGirl.create(:assignment, :employee => @ralph, :store => @oakland, :start_date => 10.months.ago.to_date, :end_date => nil, :pay_level => 3)
      @shift_ralph_1 = FactoryGirl.create(:shift, :assignment => @assign_ralph, :date => 3.days.ago.to_date)
      @shift_ralph_2 = FactoryGirl.create(:shift, :assignment => @assign_ralph, :date => 2.days.ago.to_date, :start_time => Time.local(2000,1,1,12,0,0,), :end_time => Time.local(2000,1,1,16,0,0,))
      @shift_ralph_3 = FactoryGirl.create(:shift, :assignment => @assign_ralph, :date => 1.day.ago.to_date, :start_time => Time.local(2000,1,1,13,0,0,), :end_time => Time.local(2000,1,1,14,0,0,))
      @shift_ralph_4 = FactoryGirl.create(:shift, :assignment => @assign_ralph, :date => Date.today, :start_time => Time.local(2000,1,1,13,0,0,))
      @sj_ralph_cashier = FactoryGirl.create(:shift_job, :shift => @shift_ralph_1, :job => @cashier)
      @sj_ralph_cashier2 = FactoryGirl.create(:shift_job, :shift => @shift_ralph_2, :job => @mopping)
      
      @ed = FactoryGirl.create(:employee)
      @assign_ed = FactoryGirl.create(:assignment, :employee => @ed, :store => @cmu, :end_date => nil)
      @shift_ed = FactoryGirl.create(:shift, :assignment => @assign_ed, :date => 4.days.from_now.to_date)
    end
    
    teardown do
      @cashier.destroy
      @mopping.destroy
      @making.destroy
      @mover.destroy
      
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
      @sj_kath_cashier.destroy
      
      @ralph.destroy
      @assign_ralph.destroy
      @shift_ralph_1.destroy
      @shift_ralph_2.destroy
      @shift_ralph_3.destroy
      @shift_ralph_4.destroy
      @sj_ralph_cashier.destroy
      @sj_ralph_cashier2.destroy
      
      @ed.destroy
      @assign_ed.destroy
      @shift_ed.destroy
    end
    
    should "allow active jobs to be added to shifts" do
      @shift_in_past = FactoryGirl.build(:shift_job, :shift => @shift_ralph_3, :job => @making)
      assert @shift_in_past.valid?
    end
    
    should "not allow inactive jobs to be added to shifts" do
      @shift_in_past = FactoryGirl.build(:shift_job, :shift => @shift_ralph_3, :job => @moving)
      deny @shift_in_past.valid?
    end
  end
end
