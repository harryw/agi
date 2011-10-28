# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
      name "MyString"
      name_tag "MyString"
      homepage "MyString"
      description "MyText"
      repository "MyString"
      repo_private_key "MyText"
    end
end