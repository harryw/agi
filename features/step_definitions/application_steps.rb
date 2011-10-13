def select_second_option(id)
  # choose the second item in a select list – the first item usually being a “please select” message
  second_option_xpath = "//*[@id='#{id}']/option[2]"
  second_option = find(:xpath, second_option_xpath).text
  select(second_option, :from => id)
end

Then(/^(.+?) should match route \/(.+?)$/) do |page, route|
  #regexp = route.gsub(/:(\w*?)id/,'\d+')
  #path_to(page).should =~ /#{regexp}/
  
  regexp = route.gsub(/:(\w*?)id/,'\d+')
  path_to(page).should =~ /#{regexp}$/
end

Then(/^I should be at (.+)$/) do |page|
  current_path.should == "#{path_to(page)}"
end

Then /^the current route should match \/(.+?)$/ do |route|
    regexp = route.gsub(/:(\w*?)id/,'\d+')
    current_path.should  =~ /#{regexp}$/
end