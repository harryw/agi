class Extension < ActiveRecord::Base
  has_many :customizations, :as => :customizable
  belongs_to :app
  belongs_to :addon
  attr_accessible :app_id, :addon_id
end
