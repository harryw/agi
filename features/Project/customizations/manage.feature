Feature: Project configuration
  In order to add or override customizations to a project
  As a user
  I want to manage customizations

  Background: Log-in and create a Project
    Given I am logged in
    And a project exists with name: "Balance"
    
  Scenario: New and Show customization
    When I go to the project's customization's new page
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
    Given a customization exists with name: "FooProject", value: "testing", customizable: that project
    When I go to the project's customizations page
    Then I should see "FooProject" 
    And I should see "testing"
    
  Scenario: Edit customization
    Given a customization exists with name: "FooProject", value: "testing", customizable: that project
    When I go to the project's customization's edit page
    And I fill in "Name" with "FooProjectEdited"
    And I press "Update Customization"
    Then I should see "Customization was successfully updated"
    And I should see "FooProjectEdited"
    
  Scenario: Delete a customization
    Given a customization exists with name: "FooProject", value: "testing", customizable: that project
    When I go to the project's customization's page
    And I follow "Destroy"
    Then the current route should match /projects/:id/customizations
    And I should not see "FooProject"
    