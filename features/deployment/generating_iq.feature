
Feature: Generate an IQ and upload it to S3 at deployment time

	Background: A user must be logged-in to use Agi
  	Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		And I fake the calls to opscode
		And I mock fog

	Scenario: Make a successful deployment
		Given a working_app exists
		And I go to the app's page
		And I follow "Deploy"
		And I press "Create Deployment"
		Then I should see "A deployment has been created"
		And I should see "Success"
		And I should see "OK"
		And I should see "user@test.com"
