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