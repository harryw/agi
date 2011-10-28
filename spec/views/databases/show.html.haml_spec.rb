require 'spec_helper'

describe "databases/show.html.haml" do
  before(:each) do
    @database = assign(:database, stub_model(Database,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Db Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Username/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Password/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Instance Class/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Availability Zone/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Engine Version/)
  end
end
