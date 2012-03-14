class Customization < ActiveRecord::Base
  belongs_to :customizable, :polymorphic => true
  attr_accessible :name, :location, :value, :prompt_on_deploy, :customizable_id, :customizable_type
  
  after_save :update_customizable
  
  private
  
  def update_customizable
    if customizable_type.constantize == App
      self.customizable.touch
    else
      self.customizable.save
    end
    
  end
  
end
