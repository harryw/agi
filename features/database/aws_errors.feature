Feature: When AWS fails to make a request
  As an authenticated user
  I want to capture AWS non 200 responses nicely, highlighting the agi database fields related with the aws errors
  
  Background: A user must be logged-in to use Agi
    Given I am a user named "foo" with an email "user@test.com" and password "please"
  	And I sign in as "user@test.com/please"
  	
  Scenario Outline: Capture Invalid AWS RDS Server attributes
    Given a database exists with <db_field>: "<db_value>"
    And I go to the database's page
    When I follow "Start" using a cassette named "<cassette_name>"
    Then I should see "<aws_error>"
    And I should see "<detail_error>"
    
  Scenarios: verify that aws errors are map to agi database errors
   | db_field          | db_value   | cassette_name                | aws_error                      | detail_error                         |
   | engine_version    | 4.4.44     | start-invalid_engine_version | InvalidParameterCombination    | Cannot find version 4.4.44 for mysql |
   | db_type           | posgres    | start-invalid_db_type        | InvalidParameterValue          | Invalid DB engine: posgres           |
   | availability_zone | us-east-1a | start-insufficient_capacity  | InsufficientDBInstanceCapacity | db.m1.small is not currently         |

#  Scenario Outline: Capture Invalid AWS RDS Security Group at starting time
#    Given a database exists with security_group_name: "<rds_sg>", ec2_sg_to_authorize: "<ec2_sg_to_authorize>"
#    And I go to the database's page
#    When I follow "Start" using a cassette named "<cassette_name>"
#    Then I should see "<aws_error>"
#    And I should see "<detail_error>"
#    
#  Scenarios: A rds security group is created and an ec2_sg_to_authorize is authorized before starting a rds instance 
#    | rds_sg       | ec2_sg_to_authorize | cassette_name        | aws_error             | detail_error                                   |
#    | invalid_sg.1 | new_ec2_sg          | start-invalid-rds_sg | InvalidParameterValue | DBSecurityGroupName can contain only ASCII |
#
