Feature: Allow me to manage my databases
	As an authenticated user
	I want to create, edit and delete databases
	
	Background: A user must be loged-in to use Agi
    Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		
	Scenario: Create a Database and Show
		Given I go to the databases page
		And I follow "New Database"
		And the current route should match /databases/new
	  When I fill in "Name" with "awsome-db"
	  When I fill in "Db Name" with "developdb"
	  When I fill in "Username" with "root"
	  When I fill in "Client Cert" with "jjjjjj"
	  When I select "mysql" from "Type"
	  When I fill in "Instance Storage" with "5"
	  When I select "db.m1.small" from "Instance Class"
	  When I select "us-east-1a" from "Availability Zone"
		And I press "Create Database"
		Then I should see "Database was successfully created."
		And I should see "awsome-db"
		And I should see "developdb"
		And I should see "mysql"
		
	Scenario: Edit a Database
		Given a database exists with db_name: "firstdatabase", name: "first-database"
		And I go to the database's edit page
		When I fill in "Db Name" with "firstdatabase-edit"
		And I press "Update Database"
		Then I should see "Database was successfully updated"
		And I should see "firstdatabase-edit"
		
	Scenario: Index page
    Given a database exists with name: "great-database"
    And I go to the databases page
    Then I should see "great-database"
    And the current route should match /databases

  Scenario: Shows all the rds parameter groups from agifog
    Given I go to the databases page
		And I follow "New Database" using a cassette named "query_rds_parameter_groups"
		Then I select "default.mysql5.1" from "RDS Parameter group"
		And I select "default.mysql5.5" from "RDS Parameter group"
		And I select "mdsol-mysql5-1" from "RDS Parameter group"
		And I select "mdsol-mysql5-5" from "RDS Parameter group"
		
	Scenario: Shows a warning message if it couldn't query the rds parameter groups from agifog
	  Given I go to the databases page
	  And I follow "New Database" using a cassette named "query_rds_parameter_groups-when-agifog-doesnt-response"
	  Then I should see "it failed to load rds parameter groups from agifog, using the the default one"
	  And I select "default.mysql5.5" from "RDS Parameter group"
		
		