require 'ostruct'

amazon_s3 = YAML.load_file("#{Rails.root}/config/amazon_s3.yml")[Rails.env]
mauth = YAML.load_file("#{Rails.root}/config/mauth.yml")[Rails.env]
::AppConfig = OpenStruct.new(amazon_s3.merge(mauth))