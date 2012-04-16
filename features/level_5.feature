Feature: Extra Tests
	As an professor
	I want to be able to verify students have considered additional cases
	So I can be sure they are learning and thinking

	
	# No error or display when there are no assigned employees
	Scenario: View Bistro details (no current assignments)
		Given an revised business
		When I go to Bistro details page
		Then I should see "Address: "
		And I should see "325 East Ohio"
		And I should see "Pittsburgh, PA 15212"
		And I should not see "Hersh, Jon"
		And I should not see "Pay"
		

	# No error or display when there are no assignment history
	Scenario: View details for Mark (no assignment history)
		Given an revised business
		When I go to details on Mark Heimann
		Then I should see "Heimann, Mark"
		And I should see "Phone: 724-713-3476"
		And I should not see "Phone: 4122684209"
		And I should see "Date of Birth: 01/25/93"
		And I should not see "Date of birth: 1993-01-25"
		And I should see "SSN: 084213091"
		And I should see "Active: Yes"
		And I should not see "Pay"
		And I should not see "Dates"
		And I should not see "Start"
		And I should not see "End"
		
	# No error or display when no employees yet
	Scenario: View details when only stores
		Given only stores
		When I go to the home page
		And I click on the link "Stores"
	  Then I should see "Current Stores"
		And I should see "Carnegie Mellon"
		And I click on the link "Employees"
		Then I should not see "Name"
		And I should not see "Phone"
		
	# Can see inactive stores
	Scenario: It is possible to view inactive stores
		Given only stores
		When I go to the home page
		And I click on the link "Stores"
	  Then I should see "Hazelwood"
		And I should see "Carnegie Mellon"

	# No error if employee has no phone (not required)
	Scenario: Employee with no phone is still viewable
		Given Cindy has no phone
		When I go to details on Cindy Crawford
		Then I should see "Crawford, Cindy"
		And I should see "Phone"
		And I should see "SSN: 084359822"
		And I should see "Role: Employee"
		And I should see "Active: Yes"
		And I should see "Assignment History:"
		And I should see "Carnegie Mellon"
		And I should not see "ID"
		And I should not see "_id"
		And I should not see "Created"
