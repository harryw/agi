# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customization do
      name "foo"
      location "bla.yaml"
      value "bar"
      prompt_on_deploy false
    end
end