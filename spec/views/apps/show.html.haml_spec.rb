require 'spec_helper'

describe "apps/show.html.haml" do
  before(:each) do
    @app = assign(:app, stub_model(App,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Stage Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Deploy To/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Deploy User/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Deploy Group/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Multi Tenant/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Uses Bundler/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Alert Emails/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Git Revision/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Rails Env/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Project Link/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Customer Link/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Database Link/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Chef Account Link/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Cache Cluster Link/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Infrastructure Link/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Newrelic Account Link/)
  end
end
