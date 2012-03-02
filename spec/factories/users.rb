# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
      email 'user-test@test.com'
      password 'jander'
    end
end