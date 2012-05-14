# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer do
      name "Medidata"
      name_tag "medidata"
  
    factory :customer_jnj do
        name "jnj"
        name_tag "jnj"
    end
  end
end