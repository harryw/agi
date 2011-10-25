require 'spec_helper'

describe "deployments/index.html.haml" do
  before(:each) do
    assign(:deployments, [
      stub_model(Deployment,
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
      ),
      stub_model(Deployment,
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
      )
    ])
  end

  it "renders a list of deployments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "User Link".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Git Repo".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Git Commit".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Task".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Migration Command".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
