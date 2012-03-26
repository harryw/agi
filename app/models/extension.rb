class Extension < ActiveRecord::Base
  has_many :customizations, :as => :customizable, :dependent => :destroy
  belongs_to :app
  belongs_to :addon
  attr_accessible :app_id, :addon_id
  
  def customization_hash
    hash = {}
    customizations.each{|c| hash.merge!(c.to_hash)}
    hash
  end
  
end
