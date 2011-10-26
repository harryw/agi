require 'spec_helper'

describe "databases/edit.html.haml" do
  before(:each) do
    @database = assign(:database, stub_model(Database,
      :name => "MyString",
      :db_name => "MyString",
      :username => "MyString",
      :password => "MyString",
      :client_cert => "MyText",
      :type => "",
      :instance_class => "MyString",
      :instance_storage => 1,
      :multi_az => false,
      :availability_zone => "MyString",
      :engine_version => "MyString"
    ))
  end

  it "renders the edit database form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => databases_path(@database), :method => "post" do
      assert_select "input#database_name", :name => "database[name]"
      assert_select "input#database_db_name", :name => "database[db_name]"
      assert_select "input#database_username", :name => "database[username]"
      assert_select "input#database_password", :name => "database[password]"
      assert_select "textarea#database_client_cert", :name => "database[client_cert]"
      assert_select "input#database_type", :name => "database[type]"
      assert_select "input#database_instance_class", :name => "database[instance_class]"
      assert_select "input#database_instance_storage", :name => "database[instance_storage]"
      assert_select "input#database_multi_az", :name => "database[multi_az]"
      assert_select "input#database_availability_zone", :name => "database[availability_zone]"
      assert_select "input#database_engine_version", :name => "database[engine_version]"
    end
  end
end
