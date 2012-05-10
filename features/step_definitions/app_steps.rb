When /^I should see some json data in the div id="([^"]*)"$/ do |class_name|
  #class_name.gsub!(/ /,'.') # In CSS spaces are represeted with dots (.) but ID can't have spaces
  deployed_data = page.find('#' + class_name).text
  deployed_data.should be_true
  # json is parse into a hash 
  JSON.parse(deployed_data).class.should == Hash
end

Given /^I fake the calls to opscode$/ do
    App.any_instance.stub(:update_data_bag_item).and_return(true)
    Deployment.any_instance.stub(:app_chef_account_update_data_bag_item).and_return(true)
end

Given /^I fake the call to query the ELB$/ do
    App.any_instance.stub(:get_lb_dns).and_return(true)
end

Given /^I fake the calls to s3$/ do
    Deployment.any_instance.stub(:save_iq_file).and_return(true)
end

Given /^I mock fog$/ do
  Fog.mock!
end


When /^(.*) using a cassette named "([^"]*)"$/ do |step_to_run, cassette_name|
  VCR.use_cassette(cassette_name) { step step_to_run }
end