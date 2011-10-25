# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
      name "MyString"
      formal_name "MyString"
      homepage "MyString"
      description "MyText"
      respository "MyString"
      repo_private_key "MyText"
    end
end