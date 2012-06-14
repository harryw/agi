Feature: Allow me to manage my databases
  As an authenticated user
  I want to create a database from a snapshot
  So that I can restore my database backups

  Background:
    Given I am logged in

  Scenario: The user is prompted to enter a set of fields to restore a DB snapshot
    When I view the new database configuration from a snapshot page
    Then I should see the following fields on the page:
      | field label                     | field type |
      | Name                            | text       |
      | Snapshot ID                     | text       |
      | Instance Class                  | select     |
      | Instance Storage                | text       |
      | Multi Az                        | checkbox   |
      | Availability Zone               | select     |
      | Rds Security Group              | text       |
      | EC2 Security Group to Authorize | text       |

  Scenario: When the form is filled out with DB snapshot details, a DB is created
    Given I am on the new database configuration from a snapshot page
    When I fill in "Name" with "awesome-db"
    And I fill in "Snapshot ID" with "test-snapshot-id"
    And I select "db.m1.small" from "Instance Class"
    And I fill in "Instance Storage" with "5"
    And I uncheck "Multi Az"
    And I select "us-east-1a" from "Availability Zone"
    And I fill in "Rds Security Group" with "test-rds-group"
    And I fill in "EC2 Security Group to Authorize" with "test-ec2-group"
    And I press "Create Database"
    Then I should see "Database was successfully created."
    And there should be a new database configuration named "awesome-db"
    And the database configuration should have the following attributes:
      | name                 | value            |
      | snapshot_id          | test-snapshot-id |
      | instance_class       | db.m1.small      |
      | instance_storage     | 5                |
      | multi_az             | false            |
      | availability_zone    | us-east-1a       |
      | security_group_name  | test-rds-group   |
      | ec2_sg_to_authorize  | test-ec2-group   |
