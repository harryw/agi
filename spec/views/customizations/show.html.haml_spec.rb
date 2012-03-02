require 'spec_helper'

describe "customizations/show.html.haml" do
  before(:each) do
    @customization = assign(:customization, stub_model(Customization,
      :name => "Name",
      :location => "Location",
      :value => "Value",
      :prompt_on_deploy => false,
      :customizable_id => 1,
      :customizable_type => "Customizable Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Location/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Value/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Customizable Type/)
  end
end
