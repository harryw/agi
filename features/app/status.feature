# Agi Scenarios


# Phase I - App prototyping


Feature: App Status Page  (App-Status)
  In order to manage my App
  As a user
  I want to be told my App's Properties and Deployment Status

  Background:
    	Given an app exists with the following:
		| field 				| value |
		| name					| testapp |
		| description			| This is a test app |
		| stage_name			| production |
		| deploy_to				| /mnt/mediflex |
		| deploy_user			| medidata |
		| deploy_group			| medidata |
		| multi_tenant			| true |
		| uses_bundler			| true |
		| alert_emails			| restebanez@mdsol.com, jzimmerman@mdsol.com |
		| url					| mediflex.cloudteam.com |
		| git_revision  		| 12345 |
		| rails_env				| production |
		| project_link			| testapp |
		| customer_link			| medidata |
		| database_link			| testapp |
		| chef_account_link		| production |
		| cache_cluster_link	| mediflex-cache |
		| infrastructure_link	| cid3rails-production-1 |
		| newrelic_account_link	| production |

	Scenario:  When the App has never been deployed, I should see the "Undeployed Changes" alert
		When I am on the "Properties" page for app "testapp"
		And no databag item exists on opscode with the name "testapp"
		Then I should see the text "Undeployed Changes"

	Scenario:  When the App has changed since last deployment, I should see the "Undeployed Changes" alert
		When I am on the "Properties" page for app "testapp"
		And a databag item exists on opscode with the name "testapp"
		And the timestamp on the databag item "testapp" is earlier than the mtime of app "testapp"
		Then I should see the text "Undeployed Changes"

	Scenario:  When the App has not changed since last deployment, I should not see the "Undeployed Changes" alert
		When I am on the "Properties" page for app "testapp"
		And a databag item exists on opscode with the name "testapp"
		And the timestamp on the databag item "testapp" is equal to or later than the mtime of app "testapp"
		Then I should not see the text "Undeployed Changes"

	Scenario:  When I deploy the App I should see a confirmation message
		When I click "Deploy" then "Confirm" I should see "Application testapp has been deployed!"
		And I should see "Deployed at:"
		And I should see <a timestamp>
		And I should see "JSON deployed:"
		And I should see <a valid JSON deployment object>

		Examples:
		| a timestamp		| a valid JSON deployment object	|
		| <<<INSERT>>>		| <<<INSERT>>>						|