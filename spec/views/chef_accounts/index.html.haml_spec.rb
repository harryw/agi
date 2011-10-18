require 'spec_helper'

describe "chef_accounts/index.html.haml" do
  before(:each) do
    assign(:chef_accounts, [
      stub_model(ChefAccount,
        :name => "Name",
        :formal_name => "Formal Name",
        :validator_key => "MyText",
        :client_key => "MyText",
        :databag_key => "MyText",
        :api_url => "Api Url"
      ),
      stub_model(ChefAccount,
        :name => "Name",
        :formal_name => "Formal Name",
        :validator_key => "MyText",
        :client_key => "MyText",
        :databag_key => "MyText",
        :api_url => "Api Url"
      )
    ])
  end

  it "renders a list of chef_accounts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Formal Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Api Url".to_s, :count => 2
  end
end
