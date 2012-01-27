# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :database do
      name "fake-db"
      db_name "fakedb"
      username "usuario"
      password "contrasena"
      client_cert "MyText"
      db_type "mysql"
      instance_class "db.m1.xlarge"
      instance_storage 5
      multi_az true
      availability_zone "us-east-1a"
      engine_version "5.1.57"
    end
end

Factory.define :database_in_creating_state, :parent => :database do |db|
    db.state "creating"
    db.started true
end