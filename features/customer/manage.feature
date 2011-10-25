Feature: Allow me to manage my customers
	As an authenticated user
	I want to create, edit and delete customers
	
	Background: A user must be loged-in to use Agi
    	Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		
	Scenario: Create a Customer
		Given I go to the customers page
		And I follow "New Customer"
		And the current route should match /customers/new
	    When I fill in "Name" with "mdsol"
	    And I fill in "Formal Name" with "Medidata"
		And I press "Create Customer"
		Then I should see "Customer was successfully created."
		
	Scenario: Edit a Customer
		Given a customer exists with name: "mdsol-edit", formal_name: "Medidata Editing"
		And I go to the customer's edit page
		When I fill in "Name" with "mdsol-edited"
		And I press "Update Customer"
		Then I should see "Customer was successfully updated"
		And I should see "mdsol-edited"