require 'spec_helper'

describe "chef_accounts/show.html.haml" do
  before(:each) do
    @chef_account = assign(:chef_account, stub_model(ChefAccount,
      :name => "Name",
      :formal_name => "Formal Name",
      :validator_key => "MyText",
      :client_key => "MyText",
      :databag_key => "MyText",
      :api_url => "Api Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Formal Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Api Url/)
  end
end
