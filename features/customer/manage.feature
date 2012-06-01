Feature: Allow me to manage my customers
	As an authenticated user
	I want to create, edit and delete customers
	
	Background: A user must be loged-in to use Agi
    Given I am logged in
		
	Scenario: Create a Customer and Show
		Given I go to the customers page
		And I follow "New Customer"
		And the current route should match /customers/new
	  When I fill in "Name Tag" with "mdsol"
	  And I fill in "Name" with "Medidata"
		And I press "Create Customer"
		Then I should see "Customer was successfully created."
		And I should see "Medidata"
		
	Scenario: Edit a Customer
		Given a customer exists with name_tag: "mdsol-edit", name: "Medidata Editing"
		And I go to the customer's edit page
		When I fill in "Name Tag" with "mdsol-edited"
		And I press "Update Customer"
		Then I should see "Customer was successfully updated"
		And I should see "mdsol-edited"
		
	Scenario: Index page
    Given a customer exists with name: "Great Customer"
    And I go to the customers page
    Then I should see "Great Customer"
    And the current route should match /customers