Feature: Allow me to manage my apps
	As an authenticated user
	I want to create, edit and delete apps
	
	Background: A user must be logged-in to use Agi
    Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		And a customer exists with name: "Johnson & Johnson", name_tag: "jnj"
		And a project exists with name: "Imagegateway", name_tag: "imagegateway"
		And a database exists with name: "Great-DB"
		And a chef_account exists with name: "Scratch"
		
		
	Scenario: Create an App and Show
		Given I go to the apps page
		And I follow "New App"
		And the current route should match /apps/new
		And I select "Johnson & Johnson" from "Customer"
		And I select "Imagegateway" from "Project"
		And I select "Scratch" from "Chef Account"
		And I select "Great-DB" from "Database"
		And I fill in "Stage Name" with "sandbox"
		And I press "Create App"
		Then I should see "App was successfully created."
		And I should see "imagegateway-jnj-sandbox"
		And I should see "Great-DB"
		
		
	Scenario: Edit an App
		Given a app exists with name: "Mediflex"
		And I go to the app's edit page
		When I fill in "Name" with "Mediflex-edited"
		And I press "Update App"
		Then I should see "App was successfully updated"
		And I should see "Mediflex-edited"
		
	Scenario: Index page
	  Given a app exists with url: "www.cucumber.com"
	  And I go to the apps page
	  Then I should see "www.cucumber.com"
	  And the current route should match /apps