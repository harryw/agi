When /^I (?:am on|view) the new database configuration from a snapshot page$/ do
  visit new_database_path(restore_db_instance_from_db_snapshot: true)
end

Then /^there should be a new database configuration named "(.*?)"$/ do |name|
  @database = Database.find_by_name(name)
  @database.should be
end

Then /^the database configuration should have the following attributes:$/ do |table|
  table.hashes.each do |hash|
    @database.send(hash['name']).to_s.should == hash['value']
  end
end
