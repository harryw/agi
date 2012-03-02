require 'ostruct'

amazon_s3_file = YAML.load_file("#{Rails.root}/config/amazon_s3.yml")
amazon_s3 = amazon_s3_file[Rails.env]
mauth_file = YAML.load_file("#{Rails.root}/config/mauth.yml")
mauth = mauth_file[Rails.env]
::AppConfig = OpenStruct.new(amazon_s3.merge(mauth))