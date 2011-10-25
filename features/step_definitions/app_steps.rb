When /^I should see some json data in the div id="([^"]*)"$/ do |class_name|
  #class_name.gsub!(/ /,'.') # In CSS spaces are represeted with dots (.) but ID can't have spaces
  json_data = page.find('#' + class_name).text
  json_data.should be_true
  # json is parse into a hash 
  JSON.parse(json_data).class.should == Hash
end