# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chef_account do
      name "testorg"
      formal_name "Test Opscode Account"
      validator_key "MyText"
      client_key "MyText"
      databag_key "MyText"
      api_url "MyString"
    end
end
