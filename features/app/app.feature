Feature: Show App page
		As a user
		I want Agi to show me the configuration and status of an app

	Background:
		Given an app exists

	Scenario: Show an app that has never been deployed
			And I go to the app show page
			Then I should see "Undeployed changes" alert