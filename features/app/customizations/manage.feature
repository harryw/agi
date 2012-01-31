Feature: App configuration
  In order to add or override customizations to a app
  As a user
  I want to manage customizations

  Background: Log-in and create a App
    Given I am a user named "foo" with an email "user@test.com" and password "please"
    And I sign in as "user@test.com/please"
    And a app exists with name: "Balance"
    
  Scenario: New and Show customization
    When I go to the app's customization's new page
    And I fill in "Name" with "foo"
    And I fill in "Value" with "bar"
#    And I fill in "Location" with "file.yaml"
#    And I check "Prompt On Deploy"
    And I press "Create Customization"
    Then I should see "Customization was successfully created"
    And I should see "foo"
    And I should see "bar"
#    And I should see "file.yaml"
#    And I should see "true"

  Scenario: Index customization
    Given a customization exists with name: "FooApp", value: "testing", customizable: that app
    When I go to the app's customizations page
    Then I should see "FooApp" 
    And I should see "testing"
    
  Scenario: Edit customization
    Given a customization exists with name: "FooApp", value: "testing", customizable: that app
    When I go to the app's customization's edit page
    And I fill in "Name" with "FooAppEdited"
    And I press "Update Customization"
    Then I should see "Customization was successfully updated"
    And I should see "FooAppEdited"
    
  Scenario: Delete a customization
    Given a customization exists with name: "FooApp", value: "testing", customizable: that app
    When I go to the app's customization's page
    And I follow "Destroy"
    Then the current route should match /apps/:id/customizations
    And I should not see "FooApp"
