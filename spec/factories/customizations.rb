# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customization do
      name "MyString"
      location "MyString"
      value "MyString"
      prompt_on_deploy false
      customizable_id 1
      customizable_type "MyString"
    end
end