require 'spec_helper'

describe "chef_accounts/edit.html.haml" do
  before(:each) do
    @chef_account = assign(:chef_account, stub_model(ChefAccount,
      :name => "MyString",
      :formal_name => "MyString",
      :validator_key => "MyText",
      :client_key => "MyText",
      :databag_key => "MyText",
      :api_url => "MyString"
    ))
  end

  it "renders the edit chef_account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => chef_accounts_path(@chef_account), :method => "post" do
      assert_select "input#chef_account_name", :name => "chef_account[name]"
      assert_select "input#chef_account_formal_name", :name => "chef_account[formal_name]"
      assert_select "textarea#chef_account_validator_key", :name => "chef_account[validator_key]"
      assert_select "textarea#chef_account_client_key", :name => "chef_account[client_key]"
      assert_select "textarea#chef_account_databag_key", :name => "chef_account[databag_key]"
      assert_select "input#chef_account_api_url", :name => "chef_account[api_url]"
    end
  end
end
