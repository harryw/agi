Feature: Database configuration can be created automatically from the app
	As an authenticated user
	I want to create a database configuration automatically 
	
	Background: A user must be logged-in to use Agi
    Given I am logged in
		And a customer exists with name: "Johnson & Johnson", name_tag: "jnj"
		And a project exists with name: "Imagegateway", name_tag: "imagegateway"
		And a chef_account exists with name: "Scratch"
		Then I go to the apps page
  	And I follow "New App"
  	And the current route should match /apps/new
  	And I select "Johnson & Johnson" from "Customer"
  	And I select "Imagegateway" from "Project"
  	And I select "Scratch" from "Chef Account"
  	And I fill in "Stage Name" with "sandbox"
		
Scenario: Create an App with database configuration
	Given I check "Create a new DB"
	And I fill in "EC2 Security Group to Authorize in RDS" with "random-ec2-sg" 
	And I press "Create App"
	And I should see "App was successfully created."
	And I should see "Name: imagegateway-jnj-sandbox"
	And I should see "Database Name: imagegateway-jnj-sandbox"
	When I follow "imagegateway-jnj-sandbox"
	Then I should see "State: stopped"
	And I should see "Db Name: imagegateway_jnj_sandbox"
	And I should see "Username: agi"
	And I should see "Type: mysql"
	And I should see "Instance Class: db.m1.small"
	And I should see "Instance Storage: 5"
	And I should see "Engine Version: 5.5.12"
	And I should see "Parameter Group: default.mysql5.5"
	And I should see "EC2 Security Group To Authorize: random-ec2-sg"
	
	