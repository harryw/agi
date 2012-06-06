Feature: Create a warning deployments based on the database status

	Background: A user must be logged-in to use Agi
  	Given I am logged in

	Scenario: Kick warning: There's no database configured
		Given a working_app_with_no_db exists
		And I go to the app's page
		When I follow "Deploy"
		Then I should see "WARNING: database not attached, please attach a database to this app before deploying"
		
	Scenario: Kick warning: the DB is configured but not started
		Given a working_app exists
		And I go to the app's page
		When I follow "Deploy"
		Then I should see "WARNING: database hasn't been started, please start it before deploying"
		
	Scenario: Kick warning: the DB is configured but not started
		Given a working_app_with_creating_db exists
		And I go to the app's page
		When I follow "Deploy"
		Then I should see "WARNING: database is not ready yet, please wait until the rds instance is available"
		