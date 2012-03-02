Feature: Allow me to manage my customers
	As an authenticated user
	I want to create, edit and delete customers
	
	Background: A user must be loged-in to use Agi
    Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		
	Scenario: Create a Project and Show
		Given I go to the projects page
		And I follow "New Project"
		And the current route should match /projects/new
	  When I fill in "Name" with "Medidata"
	  And I fill in "Name Tag" with "mdsol"
		And I press "Create Project"
		Then I should see "Project was successfully created."
		And I should see "Medidata"
		
	Scenario: Edit a Project
		Given a project exists with name_tag: "firstproject", name: "First Project"
		And I go to the project's edit page
		When I fill in "Name" with "firstproject-edit"
		And I press "Update Project"
		Then I should see "Project was successfully updated"
		And I should see "firstproject-edit"
		
	Scenario: Index page
    Given a customer exists with name: "Great customers"
    And I go to the customers page
    Then I should see "Great customers"
    And the current route should match /customers