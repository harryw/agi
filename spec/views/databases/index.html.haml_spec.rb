require 'spec_helper'

describe "databases/index.html.haml" do
  before(:each) do
    assign(:databases, [
      stub_model(Database,
        :name => "Name",
        :db_name => "Db Name",
        :username => "Username",
        :password => "Password",
        :client_cert => "MyText",
        :type => "Type",
        :instance_class => "Instance Class",
        :instance_storage => 1,
        :multi_az => false,
        :availability_zone => "Availability Zone",
        :engine_version => "Engine Version"
      ),
      stub_model(Database,
        :name => "Name",
        :db_name => "Db Name",
        :username => "Username",
        :password => "Password",
        :client_cert => "MyText",
        :type => "Type",
        :instance_class => "Instance Class",
        :instance_storage => 1,
        :multi_az => false,
        :availability_zone => "Availability Zone",
        :engine_version => "Engine Version"
      )
    ])
  end

  it "renders a list of databases" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Db Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Instance Class".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Availability Zone".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Engine Version".to_s, :count => 2
  end
end
