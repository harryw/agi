
#Feature: Allow me to manage my databases
#	As an authenticated user
#	I want to start and stop databases
#	
#	Background: A user must be loged-in to use Agi
#    Given I am a user named "foo" with an email "user@test.com" and password "please"
#		And I sign in as "user@test.com/please"
#  
# I don't really know what @localhost_request does, but i needed for recording the tape (not sure anymore of this)
# if you have to record this tape again, make sure to clean-up the test database, or rename the database name above	
#	@localhost_request	
#	Scenario: Star a rds instance out of AGI Database configuration
#		Given a database exists with name: "awesome-db"
#		Given I go to the database's page
#		When I follow "Start" using a cassette named "start_database"
#		And I should see "creating"
## This is for recording the tape: ruby service.rb -p 3000 -e test, the wait_for is set to 1s in the fog mocking
##		And I sleep for 2 seconds
#		Then I follow "AGI Databases" using a cassette named "started_database_index"
#		And I should see "available"
#		And I should see "rds.amazonaws.com"
#
#	Scenario: Stop a database
#		Given a database exists with name: "awesome-db-stop"
#		And I go to the database's page
#		And I follow "Start" using a cassette named "start_database-stop"
#		And I should see "creating"
##		And I sleep for 3 seconds
#		And I follow "AGI Databases" using a cassette named "started_database_index-stop"
#		And I should see "available"
#		When I follow "awesome-db-stop"
#		And I follow "Stop" using a cassette named "started_database_stop-stop"
#		Then I should see "Terminated"
		
		