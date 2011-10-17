class ChefAccount < ActiveRecord::Base
  validates_presence_of :name, :validator_key, :client_key, :api_url
end
