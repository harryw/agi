Feature: Allow me to manage my apps
	As an authenticated user
	I want to create, edit and delete apps
	
	Background: A user must be logged-in to use Agi
    Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		And a customer exists with name: "Johnson & Johnson", name_tag: "jnj"
		And a project exists with name: "Imagegateway", name_tag: "imagegateway"
		And a database exists with name: "great-db"
		And a chef_account exists with name: "Scratch"
		
		
	Scenario: Create an App and Show
		Given I go to the apps page
		And I follow "New App"
		And the current route should match /apps/new
		And I select "Johnson & Johnson" from "Customer"
		And I select "Imagegateway" from "Project"
		And I select "Scratch" from "Chef Account"
		And I select "great-db" from "Database"
		And I fill in "Stage Name" with "sandbox"
		And I press "Create App"
		Then I should see "App was successfully created."
		And I should see "imagegateway-jnj-sandbox"
		And I should see "great-db"
		
		
	Scenario: Edit an App
		Given a app exists with name: "Mediflex"
		And I go to the app's edit page
		When I fill in "Name" with "Mediflex-edited"
		And I press "Update App"
		Then I should see "App was successfully updated"
		And I should see "Mediflex-edited"
		
	Scenario: Index page
	  Given a app exists with domain: "www.cucumber.com"
	  And I go to the apps page
	  Then I should see "www.cucumber.com"
	  And the current route should match /apps
	  
  Scenario: Shows all the ec2 security groups from agifog
    Given I go to the apps page
  	And I follow "New App" using a cassette named "query_filtered_ec2_security_groups"
  	Then I select "ctms-distro-app001java" from "EC2 Security Group to Authorize in RDS"
    And I select "cid3-sandbox-app001ruby" from "EC2 Security Group to Authorize in RDS"
  
  Scenario: Shows a warning message if it couldn't query the ec2 security groups from agifog
    Given I go to the apps page
	  And I follow "New App" using a cassette named "failed-query_filtered_ec2_security_groups"
    Then I should see "it failed to load ec2 security groups from agifog, you can specifiy manually"
    And I fill in "EC2 Security Group to Authorize in RDS" with "You can specifiy a manual EC2 SG"
