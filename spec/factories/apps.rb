# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :app do
      name "Mediflex-mdsol-production"
      description "This is a test app"
      stage_name "production"
      deploy_to "/mnt/mediflex"
      deploy_user "medidata"
      deploy_group "medidata"
      multi_tenant "true"
      uses_bundler "true"
      alert_emails "restebanez@mdsol.com, jzimmerman@mdsol.com"
      url "mediflex.cloudteam.com"
      git_revision "1234567"
      rails_env "production"
      project_link "mediflex"
      customer_link "medidata"
      database_link "mediflex-database"
      chef_account_link "production"
      cache_cluster_link "mediflex-cache"
      infrastructure_link "cid3rails-production-1"
      newrelic_account_link "production"
    end
end

               