Feature: Creates a dynect CNAME record when the app is behind an elastic load balancer
  In order to easily access to an app using the imedidata.net dns zone
  An authenticated user will have to deploy
	I want to transparently create a CNAME using the 'EC2 Security Group to Authorize in RDS' field
	
	When a Medistrano cloud is created a 'project-envioroment-cloud' ec2 security group is also created. The same name convention applies if the
	ELB checkbox is enable, so when the user selects an "EC2 security group to Authorize in RDS" Agi can easily check if an ELB with the same name
	exists. When the ELB exists Agi will query AgiFog to get the ELB hostname, then a post request will be made at deploying time to Dynect through
	Agifog to create the CNAME record
	
  Background: A user must be logged-in to use Agi
    Given I am a user named "foo" with an email "user@test.com" and password "please"
		And I sign in as "user@test.com/please"
		And I fake the call to query the ELB
		And I fake the calls to opscode
		And I fake the calls to s3
		
	Scenario: Create a Dynect CNAME at deploying time
	  Given a app_with_elb exists
	 	And I go to the app's page
		And I follow "Deploy"
		When I press "Create Deployment" using a cassette named "deployment-create_dynect_cname_new"
		Then I should see "A deployment has been created"
		And I should see "OK: imagegateway-jnj-sandbox.imedidata.net CNAME was created successfully"
		And I go to the app's page
		And I should see "OK: imagegateway-jnj-sandbox.imedidata.net CNAME was created successfully"
		
	Scenario: Try to create an already existing Dynect CNAME
    Given a app_with_elb exists
 	  And I go to the app's page		
 	  And I follow "Deploy"
		When I press "Create Deployment" using a cassette named "deployment-create_dynect_cname-already_created"
		Then I should see "A deployment has been created"
		And I should see "OK: imagegateway-jnj-sandbox.imedidata.net CNAME was already created"
		And I go to the app's page
		And I should see "OK: imagegateway-jnj-sandbox.imedidata.net CNAME was already created"
		
	Scenario: Editing ec2_sg_to_authorize field in a deployed app warns that the CNAME exists but points to a different ELB hostname
	  Given a app_with_elb exists with lb_dns: "ctms-sandbox-app001java-494317.us-east-1.elb.amazonaws.com", ec2_sg_to_authorize: "ctms-sandbox-app001java"
 	  And I go to the app's page		
 	  And I follow "Deploy"
		When I press "Create Deployment" using a cassette named "deployment-create_dynect_cname-already_created"
		Then I should see "A deployment has been created"
		And I should not see "OK: imagegateway-jnj-sandbox.imedidata.net CNAME was already created"
		And I should see "ERROR: imagegateway-jnj-sandbox.imedidata.net CNAME was already created, but belongs to a different ELB hostname"
		And I go to the app's page
		And I should see "ERROR: imagegateway-jnj-sandbox.imedidata.net CNAME was already created, but belongs to a different ELB hostname"
		
	Scenario: Editing a deployed app should not show the status of the last deployment because the app name is different
	  Given I fake the calls to Dynect
	  And a app_with_elb_and_deployment exists
	  And I go to the app's page		
 	  And I should see "OK: imagegateway-jnj-sandbox.imedidata.net CNAME was created successfully"
 	  When I go to the app's edit page
 	  And I fill in "Stage Name" with "validation"
 	  And I press "Update App"
 	  Then I should not see "OK: imagegateway-jnj-sandbox.imedidata.net CNAME was created successfully"
 	  And I should see "Pending: app name has changed, It has to be deployed in order to create the CNAME in Dynect"
	 
		