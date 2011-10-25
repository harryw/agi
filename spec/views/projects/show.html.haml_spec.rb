require 'spec_helper'

describe "projects/show.html.haml" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "Name",
      :formal_name => "Formal Name",
      :homepage => "Homepage",
      :description => "MyText",
      :respository => "Respository",
      :repo_private_key => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Formal Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Homepage/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Respository/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
