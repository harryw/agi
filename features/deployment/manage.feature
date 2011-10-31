Feature: Create a full deployment

	Background: A user must be logged-in to use Agi
  	Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"

	Scenario: Make a deployment
		Given a working_app exists
		And I go to the app's page
		And I follow "Deploy"
		When I fill in "Description" with "This is a test deployment"
		And I press "Create Deployment" using a cassette named "databag_cassette"
		Then I should see "App has been deployed successfully"