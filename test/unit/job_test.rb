require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:shift_jobs)
  should have_many(:shifts).through(:shift_jobs)
  
  # Test validation
  should validate_presence_of(:name)
  
  # Test scopes in context
  # Establish context
  context "Creating a context" do
    setup do 
      @cashier = FactoryGirl.create(:job)
      @mopping = FactoryGirl.create(:job, :name => "Mopping")
      @making = FactoryGirl.create(:job, :name => "Ice cream making")
      @mover = FactoryGirl.create(:job, :name => "Mover", :active => false)
    end
    
    teardown do
      @cashier.destroy
      @mopping.destroy
      @making.destroy
      @mover.destroy
    end
    
    # test the scope 'alphabetical'
    should "shows that there are four jobs in in alphabetical order" do
      assert_equal ["Cashier", "Ice cream making", "Mopping", "Mover"], Job.alphabetical.map{|s| s.name}
    end
    
    # test the scope 'active'
    should "shows that there are two active stores" do
      assert_equal 3, Job.active.size
      assert_equal ["Cashier", "Ice cream making", "Mopping"], Job.active.alphabetical.map{|s| s.name}
    end
    
    # test the scope 'inactive'
    should "shows that there is one inactive store" do
      assert_equal 1, Job.inactive.size
      assert_equal ["Mover"], Job.inactive.alphabetical.map{|s| s.name}
    end
  end
end
