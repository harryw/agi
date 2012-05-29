Given /^I am logged in$/ do
  Capybara.current_session.reset!
  CASClient::Frameworks::Rails::Filter.fake('user@test.com')
end

Given /^I am not logged in$/ do
  Capybara.current_session.reset!
  CASClient::Frameworks::Rails::Filter.fake(nil)
end
