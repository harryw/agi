require 'spec_helper'

describe "projects/edit.html.haml" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "MyString",
      :formal_name => "MyString",
      :homepage => "MyString",
      :description => "MyText",
      :respository => "MyString",
      :repo_private_key => "MyText"
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path(@project), :method => "post" do
      assert_select "input#project_name", :name => "project[name]"
      assert_select "input#project_formal_name", :name => "project[formal_name]"
      assert_select "input#project_homepage", :name => "project[homepage]"
      assert_select "textarea#project_description", :name => "project[description]"
      assert_select "input#project_respository", :name => "project[respository]"
      assert_select "textarea#project_repo_private_key", :name => "project[repo_private_key]"
    end
  end
end
