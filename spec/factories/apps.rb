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
    updated_at "Fri, 21 Oct 2011 18:24:35 UTC +00:00"
    association :chef_account, :factory => :chef_account
    association :customer, :factory => :customer
    association :project, :factory => :project
  end

  factory :app_with_deployment, :parent => :app do |app|
    app.after_create { |a| create(:deployment, :app => a, :deployment_timestamp => a.updated_at) }
  end

  factory :working_app, :parent => :app do |a|
    a.association :chef_account, :factory => :chef_account
    a.association :database, :factory => :database
  end

  factory :working_app_ctms, :parent => :working_app do |a|
    a.association :project, :factory => :project, :platform => 'ctms'
  end

  factory :working_app_rails, :parent => :working_app do |a|
    a.association :project, :factory => :project, :platform => 'rails'
  end

  factory :working_app_with_creating_db, :parent => :app do |a|
    a.association :chef_account, :factory => :chef_account
    a.association :database, :factory => :database_in_creating_state
  end

  factory :working_app_with_no_db, :parent => :app do |a|
    a.association :chef_account, :factory => :chef_account
  end

  factory :app_with_elb, :parent => :app do |a|
    a.name "imagegateway-jnj-production"
    a.stage_name "sandbox"
    a.association :project, :factory => :project_imagegateway
    a.association :customer, :factory => :customer_jnj
    a.ec2_sg_to_authorize "ctms-distro-app001java"
    a.lb_dns "ctms-distro-app001java-1522428266.us-east-1.elb.amazonaws.com"
    a.dynect_cname_name "imagegateway-jnj-sandbox.imedidata.net"
  end

  factory :app_with_elb_and_deployment, :parent => :app_with_elb do |app|
    app.after(:create) { |a| create(:deployment, :app => a,
        :deployment_timestamp => a.updated_at,
        :dynect_cname_log => 'OK: imagegateway-jnj-sandbox.imedidata.net CNAME was created successfully') }
  end
end
  