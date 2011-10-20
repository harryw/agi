require 'spec_helper'

describe "deployments/show.html.haml" do
  before(:each) do
    @deployment = assign(:deployment, stub_model(Deployment,
      :user_link => "User Link",
      :git_repo => "Git Repo",
      :git_commit => "Git Commit",
      :description => "MyText",
      :send_email => false,
      :task => "Task",
      :do_migrations => false,
      :migration_command => "Migration Command",
      :result_log => "MyText",
      :app_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/User Link/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Git Repo/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Git Commit/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Task/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Migration Command/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
