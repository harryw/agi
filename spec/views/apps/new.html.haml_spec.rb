require 'spec_helper'

describe "apps/new.html.haml" do
  before(:each) do
    assign(:app, stub_model(App,
      :name => "MyString",
      :description => "MyString",
      :stage_name => "MyString",
      :deploy_to => "MyString",
      :deploy_user => "MyString",
      :deploy_group => "MyString",
      :multi_tenant => "MyString",
      :uses_bundler => "MyString",
      :alert_emails => "MyString",
      :url => "MyString",
      :git_revision => "MyString",
      :rails_env => "MyString",
      :project_link => "MyString",
      :customer_link => "MyString",
      :database_link => "MyString",
      :chef_account_link => "MyString",
      :cache_cluster_link => "MyString",
      :infrastructure_link => "MyString",
      :newrelic_account_link => "MyString"
    ).as_new_record)
  end

  it "renders new app form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => apps_path, :method => "post" do
      assert_select "input#app_name", :name => "app[name]"
      assert_select "input#app_description", :name => "app[description]"
      assert_select "input#app_stage_name", :name => "app[stage_name]"
      assert_select "input#app_deploy_to", :name => "app[deploy_to]"
      assert_select "input#app_deploy_user", :name => "app[deploy_user]"
      assert_select "input#app_deploy_group", :name => "app[deploy_group]"
      assert_select "input#app_multi_tenant", :name => "app[multi_tenant]"
      assert_select "input#app_uses_bundler", :name => "app[uses_bundler]"
      assert_select "input#app_alert_emails", :name => "app[alert_emails]"
      assert_select "input#app_url", :name => "app[url]"
      assert_select "input#app_git_revision", :name => "app[git_revision]"
      assert_select "input#app_rails_env", :name => "app[rails_env]"
      assert_select "input#app_project_link", :name => "app[project_link]"
      assert_select "input#app_customer_link", :name => "app[customer_link]"
      assert_select "input#app_database_link", :name => "app[database_link]"
      assert_select "input#app_chef_account_link", :name => "app[chef_account_link]"
      assert_select "input#app_cache_cluster_link", :name => "app[cache_cluster_link]"
      assert_select "input#app_infrastructure_link", :name => "app[infrastructure_link]"
      assert_select "input#app_newrelic_account_link", :name => "app[newrelic_account_link]"
    end
  end
end
