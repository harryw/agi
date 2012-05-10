Feature: Get the ELB hostname when the app is behind an elastic load balancer
  In order to find out if the App is behind a ELB
  An authenticated user will have to select a EC2 Security Group to Authorize in RDS
	I want to transparently get the ELB hostname if exists
	
	When a Medistrano cloud is created a 'project-envioroment-cloud' ec2 security group is also created. The same name convention applies if the
	ELB checkbox is enable, so when the user selects an "EC2 security group to Authorize in RDS" Agi can easily check if an ELB with the same name
	exists. When the ELB exists Agi will query AgiFog to get the ELB hostanme, then a post request will be made to Dynect through Agifog to create
	the CNAME record
	
  Background: A user must be logged-in to use Agi
    Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		And a customer exists with name: "Johnson & Johnson", name_tag: "jnj"
		And a project exists with name: "Imagegateway", name_tag: "imagegateway"
		And a database exists with name: "great-db"
		And a chef_account exists with name: "Scratch"
		
	Scenario: The user doesn't select any EC2 security group to Authorize in RDS
	  Given I go to the new app page
	  And I select "Johnson & Johnson" from "Customer"
		And I select "Imagegateway" from "Project"
		And I select "Scratch" from "Chef Account"
		And I select "great-db" from "Database"
		And I fill in "Stage Name" with "sandbox"
		And I press "Create App"
		Then I should see "App was successfully created."
		And I should see "Please, assign an EC2 SG to authorize so we can look for the AWS ELB"
		
	Scenario: The Medistrano cloud has an ELB
	  Given I go to the apps page
	  And I follow "New App" using a cassette named "query_filtered_ec2_security_groups"
	  Then I select "ctms-distro-app001java" from "EC2 Security Group to Authorize in RDS"
	  And I select "Johnson & Johnson" from "Customer"
		And I select "Imagegateway" from "Project"
		And I select "Scratch" from "Chef Account"
		And I select "great-db" from "Database"
		And I fill in "Stage Name" with "sandbox"
		And I press "Create App" using a cassette named "query_ctms-distro-app001java_elb"
		Then I should see "App was successfully created."
		And I should see "ctms-distro-app001java-1522428266.us-east-1.elb.amazonaws.com"
		And I should see "imagegateway-jnj-sandbox.imedidata.net"
		And I should see "Pending: It has to be deployed in order to create the CNAME in Dynect"
	
	Scenario: The Medistrano cloud doesn't have an ELB
	  Given I go to the apps page
	  And I follow "New App" using a cassette named "query_filtered_ec2_security_groups"
	  Then I select "eureka-sandbox-app001ruby" from "EC2 Security Group to Authorize in RDS"
	  And I select "Johnson & Johnson" from "Customer"
		And I select "Imagegateway" from "Project"
		And I select "Scratch" from "Chef Account"
		And I select "great-db" from "Database"
		And I fill in "Stage Name" with "sandbox"
		And I press "Create App" using a cassette named "query_eureka-sandbox-app001ruby_elb"
		Then I should see "App was successfully created."
		And I should see "ERROR: ELB: eureka-sandbox-app001ruby doesn't exist. Go to Medistrano and start a ELB in this cloud"
