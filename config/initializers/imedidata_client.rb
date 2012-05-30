# The casclient Gem is not Rails3 compatible. This fixes it.
require 'casclient/frameworks/rails/filter'
require 'pathname'
RAILS_ROOT = Pathname.new(File.join(File.dirname(__FILE__), '..')).cleanpath
RAILS_DEFAULT_LOGGER = Rails.logger

# Set up the default iMedidata client configuration
imed_client_config = {
  :imedidata_cas_url      => 'https://login-innovate.imedidata.com',
  :enable_single_sign_out => false,
}

# Override iMedidata client defaults with any values read from config
imed_client_config_file = "#{Rails.root}/config/imedidata_client.yml"
if File.exists? imed_client_config_file
  imed_client_config.merge!(YAML.load(File.read(imed_client_config_file)))
end

# Freeze the iMedidata client configuration into a app-wide constant
IMEDIDATA_CLIENT_CONFIG = imed_client_config

# CAS Single-Sign-On client configuration
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url           => IMEDIDATA_CLIENT_CONFIG[:imedidata_cas_url],
  :enable_single_sign_out => IMEDIDATA_CLIENT_CONFIG[:enable_single_sign_out],
  :logger                 => Rails.logger,
)


