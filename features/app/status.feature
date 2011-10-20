# Agi Scenarios
# A deployment is never automatic, a user has to press the button
# In order to know the deployment status you have to query the databag timestamp
# App#Show always show the deployment status (Never Deployed | Undeploy Changes | Deploy at: <time>)


# Phase I - App prototyping


Feature: App Status Page  (App-Status)
  In order to know if my app was either deployed or not
  As a user
  I want to be told my App's Deployment Status
  
  Background:
    Given an app exists with name: "Mediflex-mdsol-production"
	And I go to the app's page

  Scenario: A new App will show "Never Deployed" status
	Then I should see "Never Deployed"
	
  Scenario: Deploy an app successfully
	When I follow "Deploy"
	And the current route should match /apps/:id/deployments/new
	And I should see some json data in the div id="deployment_data"
	And I press "Create Deploy"
	Then I should see "App Mediflex-mdsol-production has been deployed"
    
  Scenario: Deploying an App will show a "Deploy at: <time>" status
	Given an app successfully deployed
	And I go to the app's page
	Then I should see "Deploy at:"

  Scenario: An App that has changed since last deployment will show "Undeployed Changes" alert
	Given an app successfully deployed
	And I go to the app's page
	And I should see "Deploy at:"
	When I go to the app's edit page
	And I fill in "git_revision" with "56789012"
	And I press "Update"
	Then I should see "Undeployed Changes"