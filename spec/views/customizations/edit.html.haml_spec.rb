require 'spec_helper'

describe "customizations/edit.html.haml" do
  before(:each) do
    @customization = assign(:customization, stub_model(Customization,
      :name => "MyString",
      :location => "MyString",
      :value => "MyString",
      :prompt_on_deploy => false,
      :customizable_id => 1,
      :customizable_type => "MyString"
    ))
  end

  it "renders the edit customization form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => customizations_path(@customization), :method => "post" do
      assert_select "input#customization_name", :name => "customization[name]"
      assert_select "input#customization_location", :name => "customization[location]"
      assert_select "input#customization_value", :name => "customization[value]"
      assert_select "input#customization_prompt_on_deploy", :name => "customization[prompt_on_deploy]"
      assert_select "input#customization_customizable_id", :name => "customization[customizable_id]"
      assert_select "input#customization_customizable_type", :name => "customization[customizable_type]"
    end
  end
end
