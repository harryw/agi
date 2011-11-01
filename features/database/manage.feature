Feature: Allow me to manage my databases
	As an authenticated user
	I want to create, edit and delete databases
	
	Background: A user must be loged-in to use Agi
    	Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		
	Scenario: Create a Database
		Given I go to the databases page
		And I follow "New Database"
		And the current route should match /databases/new
	    When I fill in "Name" with "Awsome DB"
	    When I fill in "Db Name" with "develop"
	    When I fill in "Username" with "root"
	    When I fill in "Password" with "pass"
	    When I fill in "Client Cert" with "jjjjjj"
	    When I fill in "Type" with "mysql"
			When I fill in "Hostname" with "127.0.0.1"
		And I press "Create Database"
		Then I should see "Database was successfully created."
		
	Scenario: Edit a Database
		Given a database exists with db_name: "firstdatabase", name: "First Database"
		And I go to the database's edit page
		When I fill in "Db Name" with "firstdatabase-edit"
		And I press "Update Database"
		Then I should see "Database was successfully updated"
		And I should see "firstdatabase-edit"