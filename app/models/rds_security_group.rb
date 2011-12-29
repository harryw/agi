class RdsSecurityGroup < ActiveResource::Base
  self.site = "http://localhost:3000/api/v1/rds/"
  self.element_name = "security_group"
  alias_attribute :name, :id
  
  # otherwise it wont find the attributes when you go to the new page
  def method_missing(method_name)
    attributes[method_name]
  end
  

end