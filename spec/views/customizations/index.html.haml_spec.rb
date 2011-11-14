require 'spec_helper'

describe "customizations/index.html.haml" do
  before(:each) do
    assign(:customizations, [
      stub_model(Customization,
        :name => "Name",
        :location => "Location",
        :value => "Value",
        :prompt_on_deploy => false,
        :customizable_id => 1,
        :customizable_type => "Customizable Type"
      ),
      stub_model(Customization,
        :name => "Name",
        :location => "Location",
        :value => "Value",
        :prompt_on_deploy => false,
        :customizable_id => 1,
        :customizable_type => "Customizable Type"
      )
    ])
  end

  it "renders a list of customizations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Value".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Customizable Type".to_s, :count => 2
  end
end
