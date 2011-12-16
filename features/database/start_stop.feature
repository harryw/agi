
Feature: Allow me to manage my databases
	As an authenticated user
	I want to start and stop databases
	
	Background: A user must be loged-in to use Agi
    Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		And a database exists with name: "awesome-db"
  
# I don't really know what localhost_request does, but if i remove it, it stops working
# if you have to record this tape again, make sure to clean-up the test database, or rename the database name above	
	@localhost_request	
	Scenario: Star a rds instance out of AGI Database configuration
		Given I go to the database's page
		When I follow "Start" using a cassette named "start_database"
		And I should see "creating"
# This is for recording the tape: ruby service.rb -p 3000 -e test, the wait_for is set to 1s in the fog mocking
#		And I sleep for 2 seconds
		Then I follow "AGI Databases" using a cassette named "started_database_index"
		And I should see "available"
		And I should see "rds.amazonaws.com"

