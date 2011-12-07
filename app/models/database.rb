#class Database < ActiveResource::Base
class Database < ReactiveResource::Base
  self.site = "http://localhost:3000/"
  self.element_name = "instance"
  has_one :app
  alias_attribute :name, :id
  
  # otherwise it wont find the attributes when you go to the new page
  def method_missing(method_name)
    attributes[method_name]
  end
#  validates_presence_of :name
end