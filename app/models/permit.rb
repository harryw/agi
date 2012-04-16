class Permit < ActiveRecord::Base
  attr_accessible :dependency_id, :port, :security_group
  belongs_to :dependency
end