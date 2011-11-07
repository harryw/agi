# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :database do
      name "MyString"
      db_name "MyString"
      username "MyString"
      password "MyString"
      hostname "127.0.0.1"
      client_cert "MyText"
      db_type "MySql"
      instance_class "MyString"
      instance_storage 1
      multi_az false
      availability_zone "MyString"
      engine_version "MyString"
    end
end