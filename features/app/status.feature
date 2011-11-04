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
    Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		And I fake the calls to opscode

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
		
	Scenario: An App's project has changed since last deployment will show "Undeployed Changes" alert
		Given a project exists with name: "balance"
		And an app_with_deployment exists with project: that project
		And I go to the app's page
		And I follow "balance"
		And I follow "Edit"
		And I fill in "Homepage" with "www.changed.com"
		And I press "Update"
		When I go to the app's page
#		Then I should see "Undeployed Changes"