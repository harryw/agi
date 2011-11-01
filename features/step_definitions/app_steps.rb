When /^I should see some json data in the div id="([^"]*)"$/ do |class_name|
  #class_name.gsub!(/ /,'.') # In CSS spaces are represeted with dots (.) but ID can't have spaces
  deployed_data = page.find('#' + class_name).text
  deployed_data.should be_true
  # json is parse into a hash 
  JSON.parse(deployed_data).class.should == Hash
end

Given /^I fake the calls to opscode$/ do
    App.any_instance.stub(:update_data_bag_item).and_return(true)
end


When /^(.*) using a cassette named "([^"]*)"$/ do |step, cassette_name|
  VCR.use_cassette(cassette_name) { When step }
end