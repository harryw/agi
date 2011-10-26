Feature: Allow me to manage my apps
	As an authenticated user
	I want to create, edit and delete apps
	
	Background: A user must be logged-in to use Agi
    	Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		And a customer exists with name_tag: "jnj", name: "Johnson & Johnson"
		
	Scenario: Create a App
		Given I go to the apps page
		And I follow "New App"
		And the current route should match /apps/new
	    When I fill in "Name" with "Mediflex"
		And I select "Johnson & Johnson" from "Customer"
		And I press "Create App"
		Then I should see "App was successfully created."
		And I should see "Johnson & Johnson"
		
	Scenario: Edit a App
		Given a app exists with name: "Mediflex"
		And I go to the app's edit page
		When I fill in "Name" with "Mediflex-edited"
		And I press "Update App"
		Then I should see "App was successfully updated"
		And I should see "Mediflex-edited"