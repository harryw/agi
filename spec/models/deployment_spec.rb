require 'spec_helper'


describe Deployment do
  before(:each) do
    App.any_instance.stub(:update_data_bag_item).and_return(true)
    Deployment.any_instance.stub(:app_chef_account_update_data_bag_item).and_return(true)
    Deployment.any_instance.stub(:save_iq_file).and_return(true)
    Deployment.any_instance.stub_chain(:user,:email).and_return("rspec")
  end
  
  it "should have four keys" do
    working_app = create(:working_app)
    deploy = working_app.deployments.create
    deploy.deployed_data.keys.should include(:id, :database, :main, :project)
  end
  
  it "RAILS platform generates a set of OS required packages" do
    working_app = create(:working_app_rails)
    working_app.project.platform.should == "rails"
    working_app.project_platform.should == "rails"
    deploy = working_app.deployments.create
    deploy.deployed_data[:main][:required_packages].should include("libxml2-dev","libxslt-dev","libmysqlclient-dev")
  end
  
  it "CTMS platform generates a set of OS required packages" do
    working_app = create(:working_app_ctms)
    working_app.project.platform.should == "ctms"
    working_app.project_platform.should == "ctms"
    deploy = working_app.deployments.create
    deploy.deployed_data[:main][:required_packages].should include("ttf-dejavu","ttf-liberation","libxerces2-java","libxerces2-java-gcj","mysql-client")
  end
  
  it "platform field shows in main and project section for legacy reasons" do
    working_app = create(:working_app_ctms)
    deploy = working_app.deployments.create
    deploy.deployed_data[:main][:platform].should == 'ctms'
    deploy.deployed_data[:project][:platform].should == 'ctms'
  end
  
  it "should have the the deployment data specified in the app" do
    working_app = create(:working_app, :deploy_user => "rspec-user", :deploy_group => "rspec-group")
    deploy = working_app.deployments.create
    deploy.deployed_data[:main][:deploy_user].should == "rspec-user"
    deploy.deployed_data[:main][:deploy_group].should == "rspec-group"
  end
  
  it "should change the name based on the app stage field" do
    working_app = create(:working_app, :stage_name => 'testing')
    deploy = working_app.deployments.create
    deploy.deployed_data[:main][:stage_name].should == 'testing'
    deploy.deployed_data[:main][:name].should =~ /-testing$/
  end
  
  it "should deploy to the same folder name as the app name" do
    working_app = create(:working_app, :stage_name => 'sandbox')
    deploy = working_app.deployments.create
    app_name = deploy.deployed_data[:main][:name]
    deploy.deployed_data[:main][:deploy_to].should == "/mnt/#{app_name}"
  end
  
  it "should have the id and main name the same" do
    working_app = create(:working_app, :stage_name => 'hendrix')
    deploy = working_app.deployments.create
    app_name = deploy.deployed_data[:main][:name]
    deploy.deployed_data[:id].should == app_name
  end
  
  it "should have the database configuration" do
    working_app = create(:working_app)
    deploy = working_app.deployments.create
    deploy.deployed_data[:database].keys.should include(:name, :db_name, :username, :password, :db_type, :hostname)
  end
  
end
