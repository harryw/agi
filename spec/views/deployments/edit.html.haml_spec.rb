require 'spec_helper'

describe "deployments/edit.html.haml" do
  before(:each) do
    @deployment = assign(:deployment, stub_model(Deployment,
      :user_link => "MyString",
      :git_repo => "MyString",
      :git_commit => "MyString",
      :description => "MyText",
      :send_email => false,
      :task => "MyString",
      :do_migrations => false,
      :migration_command => "MyString",
      :result_log => "MyText",
      :app_id => 1
    ))
  end

  it "renders the edit deployment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => deployments_path(@deployment), :method => "post" do
      assert_select "input#deployment_user_link", :name => "deployment[user_link]"
      assert_select "input#deployment_git_repo", :name => "deployment[git_repo]"
      assert_select "input#deployment_git_commit", :name => "deployment[git_commit]"
      assert_select "textarea#deployment_description", :name => "deployment[description]"
      assert_select "input#deployment_send_email", :name => "deployment[send_email]"
      assert_select "input#deployment_task", :name => "deployment[task]"
      assert_select "input#deployment_do_migrations", :name => "deployment[do_migrations]"
      assert_select "input#deployment_migration_command", :name => "deployment[migration_command]"
      assert_select "textarea#deployment_result_log", :name => "deployment[result_log]"
      assert_select "input#deployment_app_id", :name => "deployment[app_id]"
    end
  end
end
