# Agi Scenarios
# A deployment is never automatic, a user has to press the button
# In order to know the deployment status you have to query the databag timestamp
# App#Show always show the deployment status (Never Deployed | Undeploy Changes | Deploy at: <time>)


# Phase I - App prototyping


Feature: App Status Page  (App-Status)
  In order to know if my app was either deployed or not
  As a user
  I want to be told my App's Deployment Status
  
  Background: A user must be loged-in to use Agi
    Given I am logged in
		And I fake the calls to opscode
		And I fake the calls to s3

  Scenario: A new App will show "Never Deployed" status
		Given an app exists with name: "Mediflex-mdsol-production"
		And I go to the app's page
		Then I should see "Never Deployed"
	
  Scenario: Deploy an app successfully
    Given an app exists with name: "Mediflex-mdsol-production"
		And I go to the app's page
		When I follow "Deploy" 
		And the current route should match /apps/:id/deployments/new
		And I should see some json data in the div id="deployment_data"
		And I fill in "Description" with "This is cucumber"
		And I press "Create Deploy"
		Then I should see "A deployment has been created"
    
  Scenario: Deploying an App will show a "Deploy at: <time>" status
		Given an app_with_deployment exists
		And I go to the app's page
		Then I should see "Deploy at:"

  Scenario: An App that has changed since last deployment will show "Undeployed Changes" alert
		Given an app_with_deployment exists
		And I go to the app's page
		And I should see "Deploy at:"
		When I go to the app's edit page
		And I fill in "Git Revision" with "56789012"
		And I press "Update"
		Then I should see "Undeployed Changes"
		
  Scenario: An App's customizations that has changed since last deployment will show "Undeployed Changes" alert
  	Given an app_with_deployment exists
  	And I go to the app's page
  	And I should see "Deploy at:"
  	When I go to the app's page
  	And I follow "New Customization"
  	And I fill in "Name" with "foo"
  	And I fill in "Value" with "bar"
  	And I press "Create Customization"
  	And I go to the app's page
  	Then I should see "Undeployed Changes"
		
	Scenario: An App's project has changed since last deployment will show "Undeployed Changes" alert
		Given a project exists with name: "balance"
		And an app_with_deployment exists with project: that project
		And I go to the app's page
		And I follow "balance"
		And I follow "Edit"
		And I press "Update"
		When I go to the app's page
		Then I should see "Undeployed Changes"
		
	Scenario: An App's Project's customizations that has changed since last deployment will show "Undeployed Changes" alert
  	Given an app_with_deployment exists
  	And I go to the app's page
  	And I should see "Deploy at:"
  	When I go to the app's page
  	And I follow "Balance"
  	And I follow "New Customization"
  	And I fill in "Name" with "foo"
  	And I fill in "Value" with "bar"
  	And I press "Create Customization"
  	And I go to the app's page
  	Then I should see "Undeployed Changes"
		
  Scenario: An App's customer has changed since last deployment will show "Undeployed Changes" alert
  	Given a customer exists with name: "mdsol"
  	And an app_with_deployment exists with customer: that customer
  	And I go to the app's page
  	And I follow "mdsol"
  	And I follow "Edit"
  	And I fill in "Name" with "Medidata"
  	And I press "Update"
  	When I go to the app's page
  	Then I should see "Undeployed Changes"
  
  Scenario: An App's customer's customizations that has changed since last deployment will show "Undeployed Changes" alert
	  Given a customer exists with name: "mdsol"
	  And an app_with_deployment exists with customer: that customer
  	And I go to the app's page
  	And I should see "Deploy at:"
  	When I go to the app's page
  	And I follow "mdsol"
  	And I follow "New Customization"
  	And I fill in "Name" with "foo"
  	And I fill in "Value" with "bar"
  	And I press "Create Customization"
  	And I go to the app's page
  	Then I should see "Undeployed Changes"
  	
  Scenario: An App's database has changed since last deployment will show "Undeployed Changes" alert
  	Given a database exists with name: "awesomedb"
  	And an app_with_deployment exists with database: that database
  	And I go to the app's page
  	And I follow "awesomedb"
  	And I follow "Edit"
  	And I fill in "Username" with "NewUser"
  	And I press "Update"
  	When I go to the app's page
  	Then I should see "Undeployed Changes"
  	