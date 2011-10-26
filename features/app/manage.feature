Feature: Allow me to manage my apps
	As an authenticated user
	I want to create, edit and delete apps
	
	Background: A user must be logged-in to use Agi
    	Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		And a customer exists with name: "Johnson & Johnson", name_tag: "jnj"
		And a project exists with name: "Little Project"
		And a database exists with name: "Great DB"
		
	Scenario: Create an App
		Given I go to the apps page
		And I follow "New App"
		And the current route should match /apps/new
	    When I fill in "Name" with "Mediflex"
		And I select "Johnson & Johnson" from "Customer"
		And I select "Little Project" from "Project"
		And I check "Great DB"
		And I press "Create App"
		Then I should see "App was successfully created."
		And I should see "Johnson & Johnson"
		And I should see "Little Project"
		And I should see "Little Project"
		And I should see "Great DB"
		
		
	Scenario: Edit an App
		Given a app exists with name: "Mediflex"
		And I go to the app's edit page
		When I fill in "Name" with "Mediflex-edited"
		And I press "Update App"
		Then I should see "App was successfully updated"
		And I should see "Mediflex-edited"