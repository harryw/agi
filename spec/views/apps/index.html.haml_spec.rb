require 'spec_helper'

describe "apps/index.html.haml" do
  before(:each) do
    assign(:apps, [
      stub_model(App,
        :name => "Name",
        :description => "Description",
        :stage_name => "Stage Name",
        :deploy_to => "Deploy To",
        :deploy_user => "Deploy User",
        :deploy_group => "Deploy Group",
        :multi_tenant => "Multi Tenant",
        :uses_bundler => "Uses Bundler",
        :alert_emails => "Alert Emails",
        :url => "Url",
        :git_revision => "Git Revision",
        :rails_env => "Rails Env",
        :project_link => "Project Link",
        :customer_link => "Customer Link",
        :database_link => "Database Link",
        :chef_account_link => "Chef Account Link",
        :cache_cluster_link => "Cache Cluster Link",
        :infrastructure_link => "Infrastructure Link",
        :newrelic_account_link => "Newrelic Account Link"
      ),
      stub_model(App,
        :name => "Name",
        :description => "Description",
        :stage_name => "Stage Name",
        :deploy_to => "Deploy To",
        :deploy_user => "Deploy User",
        :deploy_group => "Deploy Group",
        :multi_tenant => "Multi Tenant",
        :uses_bundler => "Uses Bundler",
        :alert_emails => "Alert Emails",
        :url => "Url",
        :git_revision => "Git Revision",
        :rails_env => "Rails Env",
        :project_link => "Project Link",
        :customer_link => "Customer Link",
        :database_link => "Database Link",
        :chef_account_link => "Chef Account Link",
        :cache_cluster_link => "Cache Cluster Link",
        :infrastructure_link => "Infrastructure Link",
        :newrelic_account_link => "Newrelic Account Link"
      )
    ])
  end

  it "renders a list of apps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Stage Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Deploy To".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Deploy User".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Deploy Group".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Multi Tenant".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Uses Bundler".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Alert Emails".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Git Revision".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Rails Env".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Project Link".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Customer Link".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Database Link".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Chef Account Link".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Cache Cluster Link".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Infrastructure Link".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Newrelic Account Link".to_s, :count => 2
  end
end
