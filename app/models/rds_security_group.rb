class RdsSecurityGroup < ActiveResource::Base
  include ActiveResource::Extend::MauthSigner if AppConfig.mauth["enable_mauth"]
  include ActiveResource::Extend::ShowErrors
  self.site = "http://#{AppConfig.agifog["hostname"]}:#{AppConfig.agifog["port"]}/api/v1/rds/"
  self.element_name = "security_group"
  alias_attribute :name, :id
  
  # otherwise it wont find the attributes when you go to the new page
  def method_missing(method_name)
    attributes[method_name]
  end
  

end