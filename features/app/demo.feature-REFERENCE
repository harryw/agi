Feature: Show every out of the box pickle step
		As a new pickle and cucumber user
		I want to know every built-in step so i don't have to repeat myself

	Background: 
		Given an app exists with name: "Mediflex-mdsol-production", stage_name: "development"

	Scenario: Go to the index page
		Given I go to the apps page
		Then  the current route should match /apps
		And I should be at the apps page
		And I should see "Mediflex-mdsol-production"
	
	Scenario: Go to a show page
		Given I go to the app's page
		Then the current route should match /apps/:id
		And I should be at the app's page
		And I should see "development"
		
	Scenario: Go the edit page (in edit you can't see the values)
		Given I go to the app's edit page
		Then the current route should match /apps/:id/edit
		And I should be at the app's edit page
		And I should not see "development"
		
	Scenario: Create a new app filling up the fields (app's new page doesn't work, you get /apps/new.40)
		Given I go to the apps page
		And I follow "New App"
		And the current route should match /apps/new
		When I fill in "Name" with "testapp"
		And I press "Create App"
		Then I should see "App was successfully created."
		#And show me the page