Feature: Create a full deployment

	Background: A user must be logged-in to use Agi
  	Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		And I fake the calls to s3

	Scenario: Make a successful deployment
		Given a working_app exists
		And I go to the app's page
		And I follow "Deploy"
		When I fill in "Description" with "This is a test deployment"
		And I press "Create Deployment" using a cassette named "save_databag_item-databag_doesnt_exist"
		Then I should see "A deployment has been created"
		And I should see "Success"
		And I should see "OK"
		And I should see "user@test.com"
	
		
	Scenario: Make a deployment with invalid chef credentials
		Given a working_app exists
		And I go to the app's page
		And I follow "Deploy"
		When I fill in "Description" with "This is a test deployment"
		And I press "Create Deployment" using a cassette named "save_databag_item-error-unauthorized"
		Then I should see "A deployment has been created"
		And I should see "Failed"		
		And I should see "401"		
		And I should see "Unauthorized"
		And I should see "user@test.com"
		
	Scenario: Index
	  Given a app_with_deployment exists
	  When I go to the app's deployments page
	  Then the current route should match /apps/:id/deployments
				