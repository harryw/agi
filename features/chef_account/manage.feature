Feature: Allow me to manage my chef_accounts
  As a user
  I want to manage my chef_accounts

  Background:
    Given a chef_account exists with name: "testorg", formal_name: "Test Opscode Account"
    And I am logged in

  Scenario: Go to the index page
    Given I go to the chef_accounts page
    Then the current route should match /chef_accounts
    And I should be at the chef_accounts page
    And I should see "testorg"

  Scenario: Go to the edit page
    Given I go to the chef_account's edit page
    Then the current route should match /chef_accounts/:id/edit
    And I should be at the chef_account's edit page
    And I should see the "Update Chef account" button

  Scenario: Create a chef_account from the index page
    Given I go to the chef_accounts page
    And I follow "New Chef account"
    And the current route should match /chef_accounts/new
    When I fill in "Name" with "testorg"
    And I fill in "Client Name" with "restebanez"
    And I fill in "Validator Key" with "fakevalkeytext"
    And I fill in "Client Key" with "fakeclientkeytext"
    And I fill in "Databag Key" with "fakedatabagencryptionkey"
    And I fill in "Api Url" with "http://test.api.com"
    And I press "Create Chef account"
    Then I should see "Chef account was successfully created"
    And I should see "testorg"

  Scenario: Edit a chef_account
    Given I go to the chef_account's edit page
    Then the current route should match /chef_accounts/:id/edit
    When I fill in "Validator Key" with "EDITEDVALUE"
    And I press "Update Chef account"
    Then I should see "Chef account was successfully updated"
    And I should see "EDITEDVALUE"
