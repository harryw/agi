class RdsServer < ActiveResource::Base
  include ActiveResource::Extend::MauthSigner if AppConfig.enable_mauth
  include ActiveResource::Extend::ShowErrors
  agifog_settings = YAML.load_file(File.join(Rails.root, "config", "agifog_settings.yml"))[:agifog]
  self.site = "http://#{agifog_settings[:hostname]}:#{agifog_settings[:port]}/api/v1/rds/"
  self.element_name = "server"
  alias_attribute :name, :id
  
  # otherwise it wont find the attributes when you go to the new page
  def method_missing(method_name)
    attributes[method_name]
  end
  

end