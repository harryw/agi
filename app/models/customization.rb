class Customization < ActiveRecord::Base
  belongs_to :customizable, :polymorphic => true
  attr_accessible :name, :location, :value, :prompt_on_deploy, :customizable_id, :customizable_type
end
