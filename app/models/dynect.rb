class Dynect < ActiveResource::Base
  include ActiveResource::Extend::MauthSigner if AppConfig["mauth"]["enable_mauth"]
  include ActiveResource::Extend::ShowErrors
  self.site = "http://#{AppConfig["agifog"]["hostname"]}:#{AppConfig["agifog"]["port"]}/api/v1/dynect/zones/imedidata.net/"
  self.element_name = "node"
  #alias_attribute :id, :fqdn
  
  # otherwise it wont find the attributes when you go to the new page
  def method_missing(method_name)
    attributes[method_name]
  end
  

end