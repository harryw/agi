Feature: Allow me to manage my chef_accounts
  As a user
  I want to manage my chef_accounts

  Background:
    Given a chef_account exists with name: "testorg", formal_name: "Test Opscode Account"


  Scenario: Go to the index page
    Given I go to the chef_accounts page
    Then the current route should match /chef_accounts
    And I should be at the chef_accounts page
    And I should see "testorg"
    And I should see "Test Opscode Account"

  Scenario: Go to the edit page
    Given I go to the chef_account's edit page
    Then the current route should match /chef_accounts/:id/edit
    And I should be at the chef_account's edit page
    And I should see the "Update Chef account" button
