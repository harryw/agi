#Agi  (Medidata Application Deployment Console)

Agi is [hosted on GitHUb](https://github.com/jbz/agi)

_*"Agi provides a Web UI to Medidata's Opscode Chef-based deployment system and AWS-based infrastructure."*_

Agi provides a role-based, authenticated user interface for deploying Medidata project code and for configuring IaaS/PaaS infrastructures for that code to run on.  Agi is intended as a front end for specific REST-based services which isolate external PaaS/SaaS REST-based API calls and maintain access control and auditing records.

##Owners
J.B. Zimmerman (jzimmerman@mdsol.com)
Rodrigo Estebanez-Larzo (restebanez@mdsol.com)
Johnlouis Petitbon (jpetitbon@mdsol.com)
DevOps Team (devops@mdsol.com)

##SLT


##Description
Agi is a replacement for the Medistrano console which will slowly assume responsibilities for the various Medistrano functions.  It is a front-end, and does not interact with infrastructures or infrastructure providers directly; rather, it maintains application configuration data and uses intermediate services to ensure that each application is properly configured on the various IaaS/PaaS services which support it.

All users of Agi must have valid iMedidata accounts to log on, and all users will have roles assigned within Agi which determine their access privileges.

Agi does not maintain live state information.  As a result, Agi is not required for configured infrastructures and applications to continue functioning; only to make changes to them or create new ones.  Agi is not a point of failure for running applications.

Agi is a Ruby on Rails application.  It can be run on any Rails-compliant machine, and its only basic requirement is a connection to the Internet so as to be able to reach the API endpoint for Opscode's hosted Chef service.  All other functions are carried out using intermediate services which can be used as proxies for internet access to their respective endpoints.


##Code


##App Support


##Keywords
console application medistrano infrastructure devops

##AGIAPP configuration

Agi consumes Agifog for every AWS call is made except for S3. In order to make Agi works we first have to configure [Agifog](https://github.com/restebanez/agifog).


Requirements:

* RVM with ruby-1.9.2-p290 (you can install it using: rvm install ruby-1.9.2-p290)
* mysql
* A set of S3 or AWS credentials (This are used for reading the Medistrano PIR and uploading the IQ to a S3 bucket)
* 3th party binary for merging pdf's: Download http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-1.44-osx10.6.dmg and install it

1) Fetch the code and bundle up:

    git clone git@github.com:restebanez/agi.git agiapp
    cd agiapp # press y to accept the .rvmrc file
    bundle

2) Add AWS credentails for S3:

    cp config/amazon_s3.yml-example config/amazon_s3.yml

now you have to edit __config/amazon_s3.yml__ replacing the X with valid set of aws credentials, you can leave the X in the test section:

    development:
      access_key_id: XXXXXXXXXXXXXXXXXXXX
      secret_access_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      bucket_name: columbo-portal-test/application-iqs
      medistrano_pir_bucket_name: columbo-portal-current
    test:
      access_key_id: XXXXXXXXXXXXXXXXXXXX
      secret_access_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      bucket_name: columbo-portal-test/application-iqs
      medistrano_pir_bucket_name: columbo-portal-current


3) create the database:

    bundle exec rake db:create

4) create the tables:

    bundle exec rake db:migrate

5) run the service:

    rails s

5) test it opening a browser to http://localhost:3000, it will redirect you to the sing-up page, just create an account

6) Verifies that it can talk to Agifog

Go to http://localhost:3000/admin/rds/servers

by default it will look for agifog in localhost:3001, in case you want to edit it, the cofiguration lives on _config/agifog.yml_

    development:
      hostname: localhost
      port: 3001
      dynectzone: imedidata.net
    test:
      hostname: localhost
      port: 3001
      dynectzone: imedidata.net%

the S3 credentials and pdftk will be tested when an app is deployed

## Current errors

 New relic development is not configured. You'll see the error:

    cannot find or read /Users/xxxxxx/my_git_repos/agiapp/config/newrelic.yml

*) Factory Girl deprecation warnings. factory_girl gem was update but the syntax of the factories wasn't. You'll see the error:

    DEPRECATION WARNING: Factory.define is deprecated; use the FactoryGirl.define block syntax to declare your factory.

*) Sign-up is disable. In order to enable it you have to edit:

    app/models/user.rb

*) And add the word __:registerable__, it will look like this:

    ...
    devise :database_authenticatable, :registerable
           :recoverable, :rememberable, :trackable, :validatable

    has_many :deployments
    ...

*) There is no spec rake task. Rspec tests have to be run like:

    bundle exec rspec




