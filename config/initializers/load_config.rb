
# Verify that 3rd party pdftk binary is in the system
raise "pdftk binary couldn't be located" unless File.exists?('/usr/bin/pdftk') || File.exists?('/usr/local/bin/pdftk')

config ={}
amazon_s3_file = YAML.load_file("#{Rails.root}/config/amazon_s3.yml")
config['amazon_s3'] = amazon_s3_file[Rails.env]
mauth_file = YAML.load_file("#{Rails.root}/config/mauth.yml")
config['mauth'] = mauth_file[Rails.env]
agifog_file = YAML.load_file("#{Rails.root}/config/agifog.yml")
config['agifog'] = agifog_file[Rails.env]
::AppConfig = config