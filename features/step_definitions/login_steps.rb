Given /^I am logged in$/ do
  Capybara.current_session.reset!
  CASClient::Frameworks::Rails::Filter.fake('user1')
  FactoryGirl.create(:user, :email => 'user1@test.com', :username => 'user1')
end

Given /^I am not logged in$/ do
  Capybara.current_session.reset!
  CASClient::Frameworks::Rails::Filter.fake(nil)
end
